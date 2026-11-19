import 'package:flutter_test/flutter_test.dart';
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

  test('identitas perangkat dibuat sekali dan dipakai ulang', () async {
    final first = await ensureDeviceIdentity(db, storeId: store.id);
    final second = await ensureDeviceIdentity(db, storeId: store.id);

    expect(second.id, first.id);
    expect(second.code, first.code);
    expect(first.code, hasLength(4));

    final devices = await db.select(db.devices).get();
    expect(devices, hasLength(1));
    expect(devices.single.id, first.id);

    final setting = await readDeviceIdentity(db, storeId: store.id);
    expect(setting?.id, first.id);

    // Identitas ikut terkirim ke server supaya struk bisa diaudit.
    final queued = await (db.select(
      db.outbox,
    )..where((t) => t.targetTable.equals('devices'))).get();
    expect(queued, hasLength(1));
    expect(queued.single.rowId, first.id);
  });

  test('memanggil ulang tidak menambah antrean perangkat', () async {
    await ensureDeviceIdentity(db, storeId: store.id);
    await ensureDeviceIdentity(db, storeId: store.id);

    final queued = await (db.select(
      db.outbox,
    )..where((t) => t.targetTable.equals('devices'))).get();
    expect(queued, hasLength(1));
  });
}
