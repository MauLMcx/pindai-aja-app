/// Kontrak transport sinkron. Implementasi nyata memakai Supabase RPC;
/// tes memakai implementasi palsu tanpa jaringan.
library;

class SyncOp {
  const SyncOp({
    required this.opId,
    required this.table,
    required this.rowId,
    required this.op,
    required this.payload,
  });

  final String opId;
  final String table;
  final String rowId;
  final String op;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => {
    'op_id': opId,
    'table': table,
    'row_id': rowId,
    'op': op,
    'payload': payload,
  };
}

class PushOutcome {
  const PushOutcome({required this.opId, required this.status, this.error});

  final String opId;
  final String status;
  final String? error;

  bool get isApplied => status == 'applied' || status == 'skipped';

  factory PushOutcome.fromJson(Map<String, dynamic> json) {
    return PushOutcome(
      opId: json['op_id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'error',
      error: json['error']?.toString(),
    );
  }
}

abstract interface class SyncApi {
  Future<List<PushOutcome>> push(List<SyncOp> ops);

  /// Mengambil baris tabel dengan `server_seq > sinceSeq`.
  Future<List<Map<String, dynamic>>> pull(
    String table,
    int sinceSeq,
    int limit,
  );
}
