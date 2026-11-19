import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../auth/session_provider.dart' show lastSignedInUserSettingKey;
import '../db/app_database.dart';
import '../device/device_identity.dart';
import '../store/local_store.dart';
import '../sync/sync_schema.dart';

const String backupFormat = 'petshop-backup';
const int backupVersion = 1;
const String lastBackupAtKey = 'last_backup_at';

/// Setelan yang hanya milik perangkat dan tidak ikut backup.
const Set<String> _deviceOnlySettings = {
  deviceIdSettingKey,
  lastSignedInUserSettingKey,
  'theme_mode',
  lastBackupAtKey,
};

class BackupRestoreResult {
  const BackupRestoreResult({required this.rows, required this.tables});

  final int rows;
  final int tables;
}

/// Membuat snapshot seluruh data bisnis dalam bentuk JSON.
Future<Map<String, Object?>> buildBackup(AppDatabase db, {DateTime? at}) async {
  final tables = <String, Object?>{};
  var rowCount = 0;

  for (final table in backupTableNames) {
    final rows = await db.customSelect('SELECT * FROM $table').get();
    final encoded = <Map<String, Object?>>[];

    for (final row in rows) {
      final values = Map<String, Object?>.from(row.data);
      if (table == 'app_settings') {
        final key = values['key'];
        if (key is String && _deviceOnlySettings.contains(key)) continue;
      }
      encoded.add(values);
      rowCount++;
    }
    tables[table] = encoded;
  }

  return {
    'format': backupFormat,
    'version': backupVersion,
    'exported_at': (at ?? DateTime.now()).toUtc().toIso8601String(),
    'row_count': rowCount,
    'tables': tables,
  };
}

/// Memulihkan backup. Data lama DIGANTI, bukan digabung.
///
/// Antrean `outbox` dan posisi sinkron dikosongkan supaya server menjadi
/// sumber berikutnya, bukan mengirim ulang data lama.
Future<BackupRestoreResult> restoreBackup(
  AppDatabase db,
  String rawJson,
) async {
  final decoded = jsonDecode(rawJson);
  if (decoded is! Map<String, dynamic>) {
    throw const FormatException('File backup tidak dikenali.');
  }
  if (decoded['format'] != backupFormat) {
    throw const FormatException('File ini bukan backup aplikasi petshop.');
  }
  final version = decoded['version'];
  if (version is! int || version > backupVersion) {
    throw const FormatException('Versi backup belum didukung aplikasi ini.');
  }

  final tables = decoded['tables'];
  if (tables is! Map<String, dynamic>) {
    throw const FormatException('Isi backup tidak lengkap.');
  }

  final stores = tables['stores'];
  if (stores is! List || stores.isEmpty) {
    throw const FormatException('Backup tidak memuat data toko.');
  }

  var rowCount = 0;
  var tableCount = 0;

  // Setelan khusus perangkat (ID perangkat, tema, waktu backup) tidak ikut
  // diganti, supaya nomor struk dan pengenal sinkron perangkat tetap sama.
  final keptSettings = await (db.select(
    db.appSettings,
  )..where((t) => t.key.isIn(_deviceOnlySettings.toList()))).get();

  await db.transaction(() async {
    for (final table in backupTableNames) {
      await db.customStatement('DELETE FROM $table');
    }

    for (final table in backupTableNames) {
      final rows = tables[table];
      if (rows is! List) continue;
      var insertedForTable = 0;

      for (final rawRow in rows) {
        if (rawRow is! Map) continue;
        final row = Map<String, dynamic>.from(rawRow);

        if (table == 'app_settings') {
          final key = row['key'];
          if (key is String && _deviceOnlySettings.contains(key)) continue;
        }

        final columns = row.keys.toList();
        if (columns.isEmpty) continue;

        final placeholders = List.filled(columns.length, '?').join(', ');
        await db.customStatement(
          'INSERT OR REPLACE INTO $table (${columns.join(', ')}) '
          'VALUES ($placeholders)',
          columns.map((column) => _decodeValue(row[column])).toList(),
        );
        insertedForTable++;
        rowCount++;
      }

      if (insertedForTable > 0) tableCount++;
    }

    await db.delete(db.outbox).go();
    await db.delete(db.syncState).go();

    for (final setting in keptSettings) {
      await db
          .into(db.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              storeId: setting.storeId,
              key: setting.key,
              value: setting.value,
              updatedAt: setting.updatedAt,
            ),
          );
    }
  });

  // Pastikan toko dan identitas perangkat tetap ada setelah pemulihan.
  final store = await ensureLocalStore(db);
  await ensureDeviceIdentity(db, storeId: store.id);

  db.notifyUpdates({for (final table in backupTableNames) TableUpdate(table)});

  return BackupRestoreResult(rows: rowCount, tables: tableCount);
}

/// Menulis backup harian ke folder dokumen aplikasi.
///
/// Mengembalikan path file baru, atau null bila hari ini sudah pernah backup.
/// Salinan ke Google Drive masih manual (lihat DOCUMENTATION.md).
Future<String?> maybeCreateDailyBackup(
  AppDatabase db, {
  Directory? directory,
  DateTime? now,
}) async {
  final at = (now ?? DateTime.now()).toLocal();
  final store = await ensureLocalStore(db);

  final lastRow =
      await (db.select(db.appSettings)..where(
            (t) => t.storeId.equals(store.id) & t.key.equals(lastBackupAtKey),
          ))
          .getSingleOrNull();

  final last = DateTime.tryParse(lastRow?.value ?? '');
  if (last != null && _sameDay(last, at)) return null;

  final base = directory ?? await getApplicationDocumentsDirectory();
  final folder = Directory(p.join(base.path, 'backups'));
  await folder.create(recursive: true);

  final data = await buildBackup(db, at: at);
  final fileName = 'petshop-${_dateStamp(at)}.json';
  final file = File(p.join(folder.path, fileName));
  await file.writeAsString(jsonEncode(data), flush: true);

  await db
      .into(db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          storeId: store.id,
          key: lastBackupAtKey,
          value: at.toUtc().toIso8601String(),
          updatedAt: at.toUtc(),
        ),
      );

  await _deleteOldBackups(folder, keepDays: 14);
  return file.path;
}

Future<void> _deleteOldBackups(
  Directory folder, {
  required int keepDays,
}) async {
  final limit = DateTime.now().subtract(Duration(days: keepDays));
  try {
    await for (final entity in folder.list()) {
      if (entity is! File) continue;
      final name = p.basename(entity.path);
      if (!name.startsWith('petshop-') || !name.endsWith('.json')) continue;
      final stat = await entity.stat();
      if (stat.modified.isBefore(limit)) {
        await entity.delete();
      }
    }
  } catch (_) {
    // Pembersihan file lama tidak boleh menggagalkan backup.
  }
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

String _dateStamp(DateTime at) {
  final month = at.month.toString().padLeft(2, '0');
  final day = at.day.toString().padLeft(2, '0');
  return '${at.year}-$month-$day';
}

Object? _decodeValue(Object? value) {
  if (value == null || value is num || value is String) return value;
  if (value is bool) return value ? 1 : 0;
  return jsonEncode(value);
}
