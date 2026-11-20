import 'package:supabase_flutter/supabase_flutter.dart';

import 'sync_api.dart';

/// Transport sinkron lewat RPC Supabase (`supabase/migrations/0003_sync_rpc.sql`).
class SupabaseSyncApi implements SyncApi {
  SupabaseSyncApi({SupabaseClient? client})
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  Future<List<PushOutcome>> push(List<SyncOp> ops) async {
    if (ops.isEmpty) return const [];

    try {
      final result = await _client.rpc(
        'sync_push',
        params: {
          'p_ops': [for (final op in ops) op.toJson()],
        },
      );
      if (result is! List) {
        throw StateError('balasan sync_push tidak dikenali');
      }
      return [
        for (final item in result)
          PushOutcome.fromJson(Map<String, dynamic>.from(item as Map)),
      ];
    } on SyncNetworkException {
      rethrow;
    } catch (error) {
      throw SyncNetworkException('Gagal mengirim antrean: $error');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> pull(
    String table,
    int sinceSeq,
    int limit,
  ) async {
    try {
      final result = await _client.rpc(
        'sync_pull',
        params: {'p_table': table, 'p_since_seq': sinceSeq, 'p_limit': limit},
      );
      if (result is! List) {
        throw StateError('balasan sync_pull tidak dikenali');
      }
      return [
        for (final item in result)
          Map<String, dynamic>.from(item as Map<String, dynamic>),
      ];
    } on SyncNetworkException {
      rethrow;
    } catch (error) {
      throw SyncNetworkException('Gagal mengambil data baru: $error');
    }
  }
}
