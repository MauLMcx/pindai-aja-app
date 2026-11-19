import 'package:supabase_flutter/supabase_flutter.dart';

import 'sync_api.dart';

/// Sinkron lewat RPC Postgres `sync_push` dan `sync_pull` (lihat migrasi 0002).
class SupabaseSyncApi implements SyncApi {
  SupabaseSyncApi(this._client);

  final SupabaseClient _client;

  @override
  Future<List<SyncPushResult>> push(List<SyncPushOp> ops) async {
    try {
      final data = await _client.rpc(
        'sync_push',
        params: {'p_ops': ops.map((op) => op.toJson()).toList()},
      );
      if (data is! List) {
        throw const SyncNetworkException(
          'Jawaban server sinkron tidak dikenal.',
        );
      }
      return data.map((item) {
        final map = (item as Map).cast<String, dynamic>();
        return SyncPushResult(
          opId: '${map['op_id']}',
          status: '${map['status']}',
          error: map['error'] as String?,
          code: map['code'] as String?,
        );
      }).toList();
    } on SyncNetworkException {
      rethrow;
    } catch (error) {
      throw SyncNetworkException('Gagal mengirim antrean: $error');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> pull({
    required String table,
    required int sinceSeq,
    int limit = 500,
  }) async {
    try {
      final data = await _client.rpc(
        'sync_pull',
        params: {'p_table': table, 'p_since': sinceSeq, 'p_limit': limit},
      );
      if (data is! List) {
        throw const SyncNetworkException(
          'Jawaban server sinkron tidak dikenal.',
        );
      }
      return data.map((item) => (item as Map).cast<String, dynamic>()).toList();
    } on SyncNetworkException {
      rethrow;
    } catch (error) {
      throw SyncNetworkException('Gagal mengambil data baru: $error');
    }
  }
}
