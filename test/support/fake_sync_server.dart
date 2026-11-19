import 'package:petshop_pos/core/sync/sync_api.dart';

/// Server sinkron palsu untuk tes klien (tanpa Supabase).
///
/// Meniru perilaku penting migrasi 0002:
///   * `op_id` idempoten,
///   * barcode unik per toko,
///   * data master last-write-wins,
///   * ledger digabung (union),
///   * pull berdasarkan `server_seq`.
class FakeSyncServer implements SyncApi {
  FakeSyncServer({required this.storeId});

  final String storeId;

  final Map<String, Map<String, Map<String, Object?>>> tables = {};
  final Set<String> applied = {};

  int _seq = 0;

  /// Bila >= 0, panggilan pull ke-n (mulai 0) akan melempar error jaringan.
  int failPullAtCall = -1;
  int pullCalls = 0;

  /// Bila true, push berikutnya melempar error jaringan.
  bool failNextPush = false;

  Iterable<Map<String, Object?>> rowsOf(String table) =>
      (tables[table] ?? const {}).values;

  Map<String, Object?>? row(String table, String id) => tables[table]?[id];

  @override
  Future<List<SyncPushResult>> push(List<SyncPushOp> ops) async {
    if (failNextPush) {
      failNextPush = false;
      throw const SyncNetworkException('Jaringan putus (simulasi).');
    }

    final results = <SyncPushResult>[];
    for (final op in ops) {
      if (applied.contains(op.opId)) {
        results.add(SyncPushResult(opId: op.opId, status: 'duplicate'));
        continue;
      }

      final payload = Map<String, Object?>.from(op.payload);
      if (op.table == 'stores') {
        if (payload['id'] != storeId) {
          results.add(
            SyncPushResult(
              opId: op.opId,
              status: 'error',
              code: '42501',
              error: 'toko tidak cocok',
            ),
          );
          continue;
        }
      } else if (payload['store_id'] != storeId) {
        results.add(
          SyncPushResult(
            opId: op.opId,
            status: 'error',
            code: '42501',
            error: 'data bukan milik toko',
          ),
        );
        continue;
      }

      if (op.table == 'product_units' && payload['barcode'] != null) {
        final duplicate = rowsOf('product_units').any(
          (row) =>
              row['barcode'] == payload['barcode'] &&
              row['id'] != payload['id'],
        );
        if (duplicate) {
          results.add(
            SyncPushResult(
              opId: op.opId,
              status: 'error',
              code: '23505',
              error: 'duplicate key value violates unique constraint',
            ),
          );
          continue;
        }
      }

      final table = tables.putIfAbsent(op.table, () => {});
      final id = '${payload['id'] ?? payload['user_id'] ?? op.rowId}';
      final existing = table[id];

      final appendOnly = _appendOnly.contains(op.table);
      if (existing == null || !appendOnly) {
        final incomingUpdated = payload['updated_at'];
        final existingUpdated = existing?['updated_at'];
        final older =
            existing != null &&
            incomingUpdated is String &&
            existingUpdated is String &&
            incomingUpdated.compareTo(existingUpdated) < 0;

        if (!older) {
          final stored = Map<String, Object?>.from(payload);
          stored['server_seq'] = ++_seq;
          table[id] = stored;
        }
      }

      applied.add(op.opId);
      results.add(SyncPushResult(opId: op.opId, status: 'applied'));
    }

    return results;
  }

  @override
  Future<List<Map<String, dynamic>>> pull({
    required String table,
    required int sinceSeq,
    int limit = 500,
  }) async {
    if (failPullAtCall >= 0 && pullCalls >= failPullAtCall) {
      pullCalls++;
      throw const SyncNetworkException('Jaringan putus saat tarik data.');
    }
    pullCalls++;

    final rows =
        rowsOf(table)
            .where((row) => ((row['server_seq'] as int?) ?? 0) > sinceSeq)
            .map((row) => Map<String, dynamic>.from(row))
            .toList()
          ..sort(
            (a, b) => ((a['server_seq'] as int?) ?? 0).compareTo(
              (b['server_seq'] as int?) ?? 0,
            ),
          );

    return rows.take(limit).toList();
  }

  static const Set<String> _appendOnly = {
    'price_history',
    'stock_movements',
    'putaway_log',
    'debt_ledger',
    'purchase_items',
    'sale_items',
    'return_items',
    'stock_opname_items',
    'returns',
  };
}
