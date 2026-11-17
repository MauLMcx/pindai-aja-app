import 'dart:convert';

import '../ids.dart';
import 'app_database.dart';

/// Menulis antrean sinkron.
///
/// Aturan SPEC P1: baris bisnis dan entri `outbox` harus ditulis dalam
/// transaksi yang sama, sehingga tidak ada data lokal yang lupa dikirim.
/// Panggil dari dalam `db.transaction(...)`.
Future<void> enqueueOutbox(
  AppDatabase db, {
  required String table,
  required String rowId,
  required String op,
  required Map<String, Object?> payload,
  DateTime? at,
}) {
  return db
      .into(db.outbox)
      .insert(
        OutboxCompanion.insert(
          opId: newId(),
          targetTable: table,
          rowId: rowId,
          op: op,
          payload: jsonEncode(payload),
          createdAt: at ?? DateTime.now().toUtc(),
        ),
      );
}
