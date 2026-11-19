/// Operasi yang dikirim ke server.
class SyncPushOp {
  const SyncPushOp({
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

class SyncPushResult {
  const SyncPushResult({
    required this.opId,
    required this.status,
    this.error,
    this.code,
  });

  final String opId;

  /// `applied`, `duplicate`, atau `error`.
  final String status;
  final String? error;
  final String? code;

  bool get isOk => status == 'applied' || status == 'duplicate';
}

/// Kegagalan jaringan saat sinkron. Pesannya aman ditampilkan ke pengguna.
class SyncNetworkException implements Exception {
  const SyncNetworkException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Komunikasi sinkron dengan server. Dipisah agar mudah diuji dengan server palsu.
abstract class SyncApi {
  Future<List<SyncPushResult>> push(List<SyncPushOp> ops);

  /// Baris dengan `server_seq > sinceSeq`, urut naik.
  Future<List<Map<String, dynamic>>> pull({
    required String table,
    required int sinceSeq,
    int limit = 500,
  });
}
