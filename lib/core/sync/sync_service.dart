import 'dart:convert';
import 'dart:math' as math;

import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'sync_api.dart';

/// Daftar tabel yang boleh disinkronkan. Harus sama dengan
/// `public.sync_allowed_tables()` di server.
const syncableTables = <String>[
  'stores',
  'devices',
  'suppliers',
  'categories',
  'products',
  'product_units',
  'price_history',
  'purchases',
  'purchase_items',
  'stock_movements',
  'putaway_log',
  'customers',
  'debt_ledger',
  'sales',
  'sale_items',
  'payments',
  'returns',
  'return_items',
  'stock_opnames',
  'stock_opname_items',
  'expenses',
  'app_settings',
];

class SyncReport {
  int applied = 0;
  int skipped = 0;
  int failed = 0;
  int pulled = 0;
  final List<String> errors = [];

  bool get ok => errors.isEmpty && failed == 0;

  @override
  String toString() =>
      'SyncReport(applied: $applied, skipped: $skipped, failed: $failed, '
      'pulled: $pulled, errors: $errors)';
}

/// Mesin sinkron klien (SPEC §8).
///
/// Push: kirim `outbox` yang belum tersinkron, lalu tandai hasilnya.
/// Pull: ambil baris per tabel dengan `server_seq > last_seq`, upsert lokal,
/// simpan posisi terakhir.
class SyncService {
  SyncService(this.db, this.api, {this.batchSize = 100, this.pullLimit = 500});

  final AppDatabase db;
  final SyncApi api;
  final int batchSize;
  final int pullLimit;

  Future<SyncReport> pushOutbox() async {
    final report = SyncReport();
    final rows =
        await (db.select(db.outbox)
              ..where((t) => t.syncedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
              ..limit(batchSize))
            .get();

    if (rows.isEmpty) return report;

    final ops = <SyncOp>[
      for (final row in rows)
        SyncOp(
          opId: row.opId,
          table: row.targetTable,
          rowId: row.rowId,
          op: row.op,
          payload: _decodePayload(row.payload),
        ),
    ];

    List<PushOutcome> outcomes;
    try {
      outcomes = await api.push(ops);
    } catch (error) {
      for (final row in rows) {
        await _markFailure(row, 'jaringan: $error');
      }
      report.failed = rows.length;
      report.errors.add('push: $error');
      return report;
    }

    final byOpId = {for (final outcome in outcomes) outcome.opId: outcome};

    for (final row in rows) {
      final outcome = byOpId[row.opId];
      if (outcome == null) {
        await _markFailure(row, 'server tidak membalas op ini');
        report.failed++;
      } else if (outcome.isApplied) {
        await _markSynced(row);
        if (outcome.status == 'skipped') {
          report.skipped++;
        } else {
          report.applied++;
        }
      } else {
        await _markFailure(row, outcome.error ?? 'ditolak server');
        report.failed++;
      }
    }

    return report;
  }

  /// Menarik satu tabel sampai habis. Mengembalikan jumlah baris.
  Future<int> pullTable(String table) async {
    if (!syncableTables.contains(table)) {
      throw ArgumentError('tabel tidak disinkronkan: $table');
    }

    var since = await _lastSeq(table);
    var total = 0;

    while (true) {
      final rows = await api.pull(table, since, pullLimit);
      if (rows.isEmpty) break;

      for (final row in rows) {
        await _upsertRow(table, row);
      }

      final maxSeq = rows
          .map((row) => (row['server_seq'] as num?)?.toInt() ?? 0)
          .reduce(math.max);
      total += rows.length;

      if (maxSeq <= since) break;
      since = maxSeq;
      await _setLastSeq(table, since);

      if (rows.length < pullLimit) break;
    }

    return total;
  }

  Future<SyncReport> pullAll() async {
    final report = SyncReport();
    for (final table in syncableTables) {
      try {
        report.pulled += await pullTable(table);
      } catch (error) {
        report.errors.add('pull $table: $error');
      }
    }
    return report;
  }

  Future<SyncReport> syncNow() async {
    final report = await pushOutbox();
    final pull = await pullAll();
    report
      ..pulled += pull.pulled
      ..errors.addAll(pull.errors);
    return report;
  }

  Future<void> _markSynced(OutboxData row) {
    return (db.update(db.outbox)..where((t) => t.opId.equals(row.opId))).write(
      OutboxCompanion(
        syncedAt: Value(DateTime.now().toUtc()),
        lastError: const Value(null),
      ),
    );
  }

  Future<void> _markFailure(OutboxData row, String message) {
    return (db.update(db.outbox)..where((t) => t.opId.equals(row.opId))).write(
      OutboxCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(message),
      ),
    );
  }

  Future<int> _lastSeq(String table) async {
    final row = await (db.select(
      db.syncState,
    )..where((t) => t.key.equals('last_seq:$table'))).getSingleOrNull();
    return int.tryParse(row?.value ?? '') ?? 0;
  }

  Future<void> _setLastSeq(String table, int seq) {
    return db
        .into(db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(key: 'last_seq:$table', value: '$seq'),
        );
  }

  Map<String, Object?> _decodePayload(String payload) {
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      throw FormatException('payload outbox bukan objek JSON');
    }
    return {
      for (final entry in decoded.entries) entry.key.toString(): entry.value,
    };
  }

  Future<void> _upsertRow(String table, Map<String, dynamic> row) async {
    final tableInfo = _tableInfo(table);
    final columns = <GeneratedColumn<Object>>[];
    final variables = <Variable<Object>>[];

    for (final column in tableInfo.$columns) {
      if (!row.containsKey(column.name)) continue;
      columns.add(column);
      variables.add(_variableFor(column, row[column.name]));
    }

    if (columns.isEmpty) return;

    final primaryKey = tableInfo.$primaryKey.map((c) => c.name).toSet();
    final updateColumns = columns
        .where((c) => !primaryKey.contains(c.name))
        .toList();

    String quote(String name) => '"${name.replaceAll('"', '""')}"';

    final sql = StringBuffer()
      ..write('insert into ${quote(tableInfo.entityName)} (')
      ..write(columns.map((c) => quote(c.name)).join(', '))
      ..write(') values (')
      ..write(List.filled(columns.length, '?').join(', '))
      ..write(') on conflict (')
      ..write(tableInfo.$primaryKey.map((c) => quote(c.name)).join(', '))
      ..write(') ');

    if (updateColumns.isEmpty) {
      sql.write('do nothing');
    } else {
      sql
        ..write('do update set ')
        ..write(
          updateColumns
              .map((c) => '${quote(c.name)} = excluded.${quote(c.name)}')
              .join(', '),
        );
    }

    await db.customInsert(
      sql.toString(),
      variables: variables,
      updates: {tableInfo},
    );
  }

  TableInfo<Table, Object?> _tableInfo(String name) {
    for (final table in db.allTables) {
      if (table.entityName == name) return table;
    }
    throw StateError('tabel lokal tidak dikenal: $name');
  }

  Variable<Object> _variableFor(GeneratedColumn<Object> column, Object? raw) {
    final type = column.type;

    if (type == DriftSqlType.bool) {
      return Variable<bool>(raw as bool?);
    }
    if (type == DriftSqlType.int) {
      return Variable<int>(
        raw == null ? null : (raw is num ? raw.toInt() : int.parse('$raw')),
      );
    }
    if (type == DriftSqlType.bigInt) {
      return Variable<BigInt>(raw == null ? null : BigInt.parse('$raw'));
    }
    if (type == DriftSqlType.double) {
      return Variable<double>(
        raw == null
            ? null
            : (raw is num ? raw.toDouble() : double.parse('$raw')),
      );
    }
    if (type == DriftSqlType.dateTime) {
      return Variable<DateTime>(
        raw == null ? null : DateTime.parse('$raw').toUtc(),
      );
    }
    if (type == DriftSqlType.blob) {
      return Variable<Uint8List>(
        raw is Uint8List ? raw : Uint8List.fromList((raw as List).cast<int>()),
      );
    }

    // Teks, termasuk kolom enum yang disimpan sebagai snake_case.
    return Variable<String>(raw?.toString());
  }
}
