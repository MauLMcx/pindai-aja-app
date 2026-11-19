import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/backup/backup_service.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/device/device_identity.dart';
import 'package:petshop_pos/core/store/local_store.dart';

void main() {
  late AppDatabase db;
  late Store store;

  setUp(() async {
    db = AppDatabase.memory();
    store = await ensureLocalStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('backup lalu pulihkan mengembalikan produk dan setelan toko', () async {
    final now = DateTime.utc(2026, 11, 19, 9);
    await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            id: 'p1',
            storeId: store.id,
            name: 'Pakan Uji',
            baseUnit: 'gram',
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: store.id,
            key: 'theme_mode',
            value: 'dark',
            updatedAt: now,
          ),
        );

    final snapshot = await buildBackup(db, at: now);
    expect(snapshot['format'], backupFormat);
    expect(snapshot['version'], backupVersion);

    // Setelan perangkat tidak ikut tercatat di backup.
    final settings = (snapshot['tables'] as Map)['app_settings'] as List;
    expect(settings.any((row) => (row as Map)['key'] == 'theme_mode'), isFalse);

    final json = jsonEncode(snapshot);

    final target = AppDatabase.memory();
    addTearDown(target.close);
    final targetStore = await ensureLocalStore(target);
    final deviceBefore = await ensureDeviceIdentity(
      target,
      storeId: targetStore.id,
    );
    await target
        .into(target.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: targetStore.id,
            key: 'theme_mode',
            value: 'light',
            updatedAt: now,
          ),
        );

    final result = await restoreBackup(target, json);
    expect(result.rows, greaterThan(0));

    final products = await target.select(target.products).get();
    expect(products.single.name, 'Pakan Uji');

    // Tema adalah pilihan perangkat; pulihkan data tidak mengubahnya.
    final theme = await (target.select(
      target.appSettings,
    )..where((t) => t.key.equals('theme_mode'))).getSingle();
    expect(theme.value, 'light');

    // Setelan perangkat tidak ikut diganti oleh backup lama.
    final deviceAfter = await readDeviceIdentity(
      target,
      storeId: targetStore.id,
    );
    expect(deviceAfter?.id, deviceBefore.id);

    // Data bisnis tidak dikirim ulang dari backup; hanya identitas perangkat
    // yang dipastikan ada lagi di server.
    final outbox = await target.select(target.outbox).get();
    expect(outbox.every((row) => row.targetTable == 'devices'), isTrue);
  });

  test('file backup yang bukan milik aplikasi ditolak', () async {
    expect(
      () => restoreBackup(db, '{"format":"lain"}'),
      throwsA(isA<FormatException>()),
    );
    expect(() => restoreBackup(db, 'bukan json'), throwsA(anything));
  });

  test('backup harian hanya sekali sehari', () async {
    final dir = await Directory.systemTemp.createTemp('petshop-backup');
    addTearDown(() => dir.delete(recursive: true));

    final first = await maybeCreateDailyBackup(
      db,
      directory: dir,
      now: DateTime(2026, 11, 19, 8),
    );
    expect(first, isNotNull);
    expect(File(first!).existsSync(), isTrue);

    final second = await maybeCreateDailyBackup(
      db,
      directory: dir,
      now: DateTime(2026, 11, 19, 20),
    );
    expect(second, isNull);

    final nextDay = await maybeCreateDailyBackup(
      db,
      directory: dir,
      now: DateTime(2026, 11, 20, 8),
    );
    expect(nextDay, isNotNull);
  });
}
