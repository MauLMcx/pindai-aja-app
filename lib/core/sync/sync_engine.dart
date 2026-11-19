import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'sync_api.dart';
import 'sync_pull_applier.dart';
import 'sync_schema.dart';

class SyncOutcome {
  const SyncOutcome({
    this.pushed = 0,
    this.duplicates = 0,
    this.failed = 0,
    this.pulled = 0,
    this.error,
  });

  final int pushed;
  final int duplicates;
  final int failed;
  final int pulled;
  final String? error;

  bool get isClean => error == null && failed == 0;

  SyncOutcome copyWith({
    int? pushed,
    int? duplicates,
    int? failed,
    int? pulled,
    String? error,
  }) {
    return SyncOutcome(
      pushed: pushed ?? this.pushed,
      duplicates: duplicates ?? this.duplicates,
      failed: failed ?? this.failed,
      pulled: pulled ?? this.pulled,
      error: error ?? this.error,
    );
  }
}

/// Pekerja sinkron: kirim outbox berurutan, lalu tarik data baru.
///
/// Satu operasi yang gagal tidak menghentikan operasi lain (SPEC §8). Jaringan
/// putus menghentikan proses dan posisi terakhir tetap tersimpan, sehingga
/// sinkron berikutnya melanjutkan dari cursor `sync_state` (S7).
class SyncEngine {
  SyncEngine({required this.db, required this.api, DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc());

  final AppDatabase db;
  final SyncApi api;
  final DateTime Function() _clock;
  late final SyncPullApplier _applier = SyncPullApplier(db);

  static const int batchSize = 25;
  static const int pullLimit = 500;

  Future<SyncOutcome> syncNow({bool force = false}) async {
    final outcome = await _push(force: force);
    if (outcome.error != null) return outcome;

    final pulled = await _pullAll();
    return outcome.copyWith(pulled: pulled.pulled, error: pulled.error);
  }

  Future<SyncOutcome> _push({required bool force}) async {
    var pushed = 0;
    var duplicates = 0;
    var failed = 0;
    final attempted = <String>{};

    while (true) {
      final now = _clock();
      final pending =
          await (db.select(db.outbox)
                ..where((t) => t.syncedAt.isNull())
                ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
                ..limit(batchSize))
              .get();

      final due = pending
          .where(
            (row) => !attempted.contains(row.opId) && _isDue(row, now, force),
          )
          .toList();
      if (due.isEmpty) break;
      attempted.addAll(due.map((row) => row.opId));

      final ops = due.map(_toOp).toList();
      List<SyncPushResult> results;
      try {
        results = await api.push(ops);
      } on SyncNetworkException catch (error) {
        await _markNetworkFailure(due, error.message, now);
        return SyncOutcome(
          pushed: pushed,
          duplicates: duplicates,
          failed: failed + due.length,
          error: error.message,
        );
      }

      final byOp = {for (final result in results) result.opId: result};
      for (final row in due) {
        final result = byOp[row.opId];
        if (result == null) {
          failed++;
          await _markFailed(row, 'Server tidak menjawab operasi ini.', now);
          continue;
        }

        if (result.isOk) {
          if (result.status == 'duplicate') {
            duplicates++;
          } else {
            pushed++;
          }
          await _markSynced(row, now);
        } else {
          failed++;
          await _markFailed(row, _messageFor(result), now);
        }
      }
    }

    return SyncOutcome(pushed: pushed, duplicates: duplicates, failed: failed);
  }

  Future<SyncOutcome> _pullAll() async {
    var total = 0;

    for (final spec in syncTableSpecs) {
      var since = await _applier.cursor(spec.name);

      while (true) {
        List<Map<String, dynamic>> rows;
        try {
          rows = await api.pull(
            table: spec.name,
            sinceSeq: since,
            limit: pullLimit,
          );
        } on SyncNetworkException catch (error) {
          return SyncOutcome(
            pulled: total,
            error: '${error.message} (data terakhir tetap aman)',
          );
        }

        if (rows.isEmpty) break;

        await _applier.apply(spec, rows);
        total += rows.length;

        final maxSeq = rows
            .map((row) => _asInt(row['server_seq']))
            .whereType<int>()
            .fold<int>(0, max);
        if (maxSeq > since) since = maxSeq;

        if (rows.length < pullLimit) break;
      }
    }

    await db
        .into(db.syncState)
        .insertOnConflictUpdate(
          SyncStateCompanion.insert(
            key: 'last_sync_at',
            value: _clock().toIso8601String(),
          ),
        );

    return SyncOutcome(pulled: total);
  }

  bool _isDue(OutboxData row, DateTime now, bool force) {
    if (force) return true;
    final last = row.lastAttemptAt;
    if (last == null || row.attempts == 0) return true;

    final seconds = min(5 * (1 << min(row.attempts, 7)), 900);
    return now.isAfter(last.add(Duration(seconds: seconds)));
  }

  SyncPushOp _toOp(OutboxData row) {
    final decoded = jsonDecode(row.payload);
    return SyncPushOp(
      opId: row.opId,
      table: row.targetTable,
      rowId: row.rowId,
      op: row.op,
      payload: decoded is Map<String, dynamic>
          ? decoded
          : Map<String, dynamic>.from(decoded as Map),
    );
  }

  Future<void> _markSynced(OutboxData row, DateTime now) {
    return (db.update(db.outbox)..where((t) => t.opId.equals(row.opId))).write(
      OutboxCompanion(
        syncedAt: Value(now),
        lastError: const Value(null),
        lastAttemptAt: Value(now),
      ),
    );
  }

  Future<void> _markFailed(OutboxData row, String message, DateTime now) {
    return (db.update(db.outbox)..where((t) => t.opId.equals(row.opId))).write(
      OutboxCompanion(
        attempts: Value(row.attempts + 1),
        lastError: Value(message),
        lastAttemptAt: Value(now),
      ),
    );
  }

  Future<void> _markNetworkFailure(
    List<OutboxData> rows,
    String message,
    DateTime now,
  ) async {
    for (final row in rows) {
      await _markFailed(row, message, now);
    }
  }

  String _messageFor(SyncPushResult result) {
    if (result.code == '23505') {
      return 'Bentrok: barcode atau nomor sudah dipakai perangkat lain. '
          'Perlu diselesaikan.';
    }
    if (result.code == '42501') {
      return 'Tidak berhak mengirim data ini. Coba masuk ulang.';
    }
    return result.error ?? 'Gagal dikirim ke server.';
  }

  int? _asInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
