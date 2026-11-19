import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../auth/session_provider.dart';
import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../supabase/supabase_config.dart';
import 'supabase_sync_api.dart';
import 'sync_api.dart';
import 'sync_engine.dart';

final syncApiProvider = Provider<SyncApi?>((ref) {
  if (!isSupabaseReady) return null;
  return SupabaseSyncApi(Supabase.instance.client);
});

final syncEngineProvider = Provider<SyncEngine?>((ref) {
  final api = ref.watch(syncApiProvider);
  if (api == null) return null;
  final db = ref.watch(appDatabaseProvider);
  return SyncEngine(db: db, api: api);
});

class SyncStatus {
  const SyncStatus({
    this.pending = 0,
    this.failed = 0,
    this.conflicts = 0,
    this.lastSyncAt,
    this.running = false,
    this.message,
  });

  final int pending;
  final int failed;
  final int conflicts;
  final DateTime? lastSyncAt;
  final bool running;
  final String? message;

  bool get hasWork => pending > 0 || failed > 0;

  SyncStatus copyWith({
    int? pending,
    int? failed,
    int? conflicts,
    DateTime? lastSyncAt,
    bool? running,
    String? message,
  }) {
    return SyncStatus(
      pending: pending ?? this.pending,
      failed: failed ?? this.failed,
      conflicts: conflicts ?? this.conflicts,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      running: running ?? this.running,
      message: message ?? this.message,
    );
  }
}

class SyncController extends AsyncNotifier<SyncStatus> {
  @override
  Future<SyncStatus> build() => _load();

  Future<void> reload() async {
    state = AsyncData(await _load());
    ref.invalidate(syncConflictsProvider);
  }

  Future<void> dismissConflict(String key) async {
    final db = ref.read(appDatabaseProvider);
    await (db.delete(db.syncState)..where((t) => t.key.equals(key))).go();
    ref.invalidate(syncConflictsProvider);
  }

  Future<SyncOutcome?> syncNow({bool force = true}) async {
    final engine = ref.read(syncEngineProvider);
    if (engine == null) {
      state = AsyncData(
        await _load(
          message:
              'Sinkron belum diatur di perangkat ini. '
              'Aplikasi tetap bisa dipakai offline.',
        ),
      );
      return null;
    }

    final session = ref.read(sessionProvider).value;
    if (session == null || session.status != SessionStatus.signedIn) {
      state = AsyncData(
        await _load(message: 'Masuk ke akun toko dulu untuk sinkron.'),
      );
      return null;
    }

    final previous = state.value ?? await _load();
    state = AsyncData(previous.copyWith(running: true, message: null));

    try {
      final outcome = await engine.syncNow(force: force);
      state = AsyncData(await _load(outcome: outcome));
      ref.invalidate(syncConflictsProvider);
      return outcome;
    } catch (error) {
      state = AsyncData(
        (await _load()).copyWith(
          running: false,
          message: 'Sinkron gagal: $error',
        ),
      );
      ref.invalidate(syncConflictsProvider);
      return null;
    }
  }

  Future<SyncStatus> _load({SyncOutcome? outcome, String? message}) async {
    final db = ref.read(appDatabaseProvider);
    final rows = await (db.select(
      db.outbox,
    )..where((t) => t.syncedAt.isNull())).get();

    final failed = rows.where((row) => row.lastError != null).length;
    final conflicts = rows
        .where((row) => row.lastError?.startsWith('Bentrok') ?? false)
        .length;

    final lastSyncRow = await (db.select(
      db.syncState,
    )..where((t) => t.key.equals('last_sync_at'))).getSingleOrNull();
    final lastSyncAt = DateTime.tryParse(lastSyncRow?.value ?? '');

    final text = switch (outcome) {
      null => message,
      _ when outcome.error != null => outcome.error,
      _ when outcome.failed > 0 =>
        '${outcome.failed} operasi gagal dikirim. Lihat antrean sinkron.',
      _ when outcome.pushed + outcome.duplicates + outcome.pulled > 0 =>
        'Sinkron selesai: ${outcome.pushed} terkirim, '
            '${outcome.pulled} data baru.',
      _ => message ?? 'Sudah tersinkron.',
    };

    return SyncStatus(
      pending: rows.length,
      failed: failed,
      conflicts: conflicts,
      lastSyncAt: lastSyncAt,
      message: text,
    );
  }
}

final syncControllerProvider =
    AsyncNotifierProvider<SyncController, SyncStatus>(SyncController.new);

/// Antrean untuk layar "Antrean sinkron" — hanya yang belum terkirim.
final syncQueueProvider = StreamProvider<List<OutboxData>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.outbox)
        ..where((t) => t.syncedAt.isNull())
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
      .watch();
});

class SyncConflict {
  const SyncConflict({
    required this.key,
    required this.table,
    required this.rowId,
    required this.message,
  });

  final String key;
  final String table;
  final String rowId;
  final String message;
}

/// Baris yang tidak bisa diterapkan saat pull (misalnya barcode bentrok).
final syncConflictsProvider = FutureProvider<List<SyncConflict>>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  final rows = await (db.select(
    db.syncState,
  )..where((t) => t.key.like('conflict:%'))).get();

  return rows.map((row) {
    final parts = row.key.split(':');
    return SyncConflict(
      key: row.key,
      table: parts.length > 1 ? parts[1] : '?',
      rowId: parts.length > 2 ? parts[2] : '?',
      message: row.value,
    );
  }).toList();
});
