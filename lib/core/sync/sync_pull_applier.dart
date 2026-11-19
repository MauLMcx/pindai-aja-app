import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'sync_schema.dart';

/// Menerapkan baris hasil `sync_pull` ke SQLite lokal.
///
/// Semua penulisan memakai upsert agar aman diulang (SPEC P8). Data master
/// memakai last-write-wins berdasarkan `updated_at`; ledger hanya ditambah.
class SyncPullApplier {
  SyncPullApplier(this.db);

  final AppDatabase db;

  Future<int> apply(SyncTableSpec spec, List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return 0;

    var maxSeq = 0;
    await db.transaction(() async {
      for (final row in rows) {
        try {
          await _upsert(spec, row);
          await _clearConflict(spec, row);
        } catch (error) {
          // Baris ini tidak bisa diterapkan (misalnya barcode bentrok dengan
          // baris lokal). Catat untuk layar "Perlu diselesaikan", lalu lanjut.
          await _recordConflict(spec, row, error);
        }

        final seq = _asInt(row['server_seq']);
        if (seq != null && seq > maxSeq) maxSeq = seq;

        if (spec.storesServerSeq) {
          // stock_movements menyimpan server_seq di kolomnya sendiri.
          await _storeMovementSeq(row, seq);
        }
      }

      if (maxSeq > 0) {
        await _writeCursor(spec.name, maxSeq);
      }
    });

    // Beri tahu stream Drift agar daftar produk/laporan ikut segar.
    db.notifyUpdates({TableUpdate(spec.name)});
    return rows.length;
  }

  Future<int> cursor(String table) async {
    final row = await (db.select(
      db.syncState,
    )..where((t) => t.key.equals(_cursorKey(table)))).getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  Future<void> _upsert(SyncTableSpec spec, Map<String, dynamic> row) async {
    final columns = <String>[];
    final values = <Object?>[];

    for (final column in spec.columns) {
      if (!row.containsKey(column)) continue;
      columns.add(column);
      values.add(_encodeValue(spec, column, row[column]));
    }

    if (columns.isEmpty) return;

    final placeholders = List.filled(columns.length, '?').join(', ');
    final updates = columns
        .where((column) => column != spec.conflictTarget)
        .map((column) => '$column = excluded.$column')
        .join(', ');

    final buffer = StringBuffer()
      ..write('INSERT INTO ${spec.name} (${columns.join(', ')}) ')
      ..write('VALUES ($placeholders)');

    switch (spec.mode) {
      case SyncMode.appendOnly:
        buffer.write(' ON CONFLICT (${spec.conflictTarget}) DO NOTHING');
      case SyncMode.upsert:
        buffer.write(
          ' ON CONFLICT (${spec.conflictTarget}) DO UPDATE SET $updates',
        );
      case SyncMode.lastWriteWins:
        buffer.write(
          ' ON CONFLICT (${spec.conflictTarget}) DO UPDATE SET $updates '
          'WHERE excluded.updated_at >= ${spec.name}.updated_at',
        );
    }

    await db.customStatement(buffer.toString(), values);
  }

  Future<void> _storeMovementSeq(Map<String, dynamic> row, int? seq) async {
    if (seq == null) return;
    final id = row['id'];
    if (id is! String) return;
    await (db.update(db.stockMovements)..where((t) => t.id.equals(id))).write(
      StockMovementsCompanion(serverSeq: Value(seq)),
    );
  }

  Future<void> _writeCursor(String table, int seq) {
    return db
        .into(db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(key: _cursorKey(table), value: '$seq'),
        );
  }

  String _cursorKey(String table) => 'last_pulled_seq:$table';

  Future<void> _recordConflict(
    SyncTableSpec spec,
    Map<String, dynamic> row,
    Object error,
  ) async {
    final key = _conflictKey(spec, row);
    if (key == null) return;
    final text = '$error';
    await db
        .into(db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(
            key: key,
            value: text.length > 300 ? text.substring(0, 300) : text,
          ),
        );
  }

  Future<void> _clearConflict(
    SyncTableSpec spec,
    Map<String, dynamic> row,
  ) async {
    final key = _conflictKey(spec, row);
    if (key == null) return;
    await (db.delete(db.syncState)..where((t) => t.key.equals(key))).go();
  }

  String? _conflictKey(SyncTableSpec spec, Map<String, dynamic> row) {
    final id = row[spec.conflictTarget];
    if (id == null) return null;
    return 'conflict:${spec.name}:$id';
  }

  Object? _encodeValue(SyncTableSpec spec, String column, Object? value) {
    if (value == null) return null;

    final enumMap = spec.enumColumns[column];
    if (enumMap != null) {
      final mapped = enumMap[value];
      if (mapped == null) {
        throw FormatException(
          'Nilai $column tidak dikenal dari server: $value',
        );
      }
      return mapped;
    }

    if (spec.dateColumns.contains(column)) {
      final date = _asDate(value);
      return date == null ? null : date.millisecondsSinceEpoch ~/ 1000;
    }

    if (spec.boolColumns.contains(column)) {
      if (value is bool) return value ? 1 : 0;
      if (value is num) return value == 0 ? 0 : 1;
      if (value is String) return value == 'true' ? 1 : 0;
      return 0;
    }

    if (spec.realColumns.contains(column)) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    if (value is Map || value is List) return jsonEncode(value);
    if (value is bool) return value ? 1 : 0;
    return value;
  }

  DateTime? _asDate(Object? value) {
    if (value is DateTime) return value;
    if (value is num) {
      // Supabase mengirim ISO string, tetapi terima juga detik/milidetik.
      final raw = value.toInt();
      return DateTime.fromMillisecondsSinceEpoch(
        raw > 100000000000 ? raw : raw * 1000,
        isUtc: true,
      );
    }
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
