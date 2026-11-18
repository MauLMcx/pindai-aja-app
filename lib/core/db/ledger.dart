import 'package:drift/drift.dart';

import 'app_database.dart';
import 'outbox_writer.dart';

/// Stok saat ini = jumlah seluruh mutasi (SPEC P2).
Future<int> stockBaseOf(AppDatabase db, String productId) =>
    db.stockBase(productId);

/// Rata-rata biaya per satuan dasar dengan metode rata-rata bergerak.
///
/// Setiap penerimaan (mutasi positif dengan biaya) memperbarui rata-rata
/// memakai stok berjalan, sesuai SPEC §6.3:
/// `(max(stok,0) × avg_lama + qty_masuk × biaya_masuk) / (max(stok,0) + qty_masuk)`.
/// Dipakai sebagai snapshot HPP saat penjualan (SPEC §6.10). Nilai null berarti
/// belum ada penerimaan dengan biaya tercatat.
Future<double?> averageCostBaseOf(AppDatabase db, String productId) async {
  final rows =
      await (db.select(db.stockMovements)
            ..where((t) => t.productId.equals(productId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.occurredAt),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .get();

  var stock = 0;
  double? average;
  for (final row in rows) {
    if (row.qtyBaseDelta > 0 && row.costPerBase != null) {
      final inQty = row.qtyBaseDelta;
      final inCost = row.costPerBase!;
      final base = stock > 0 ? stock : 0;
      final totalQty = base + inQty;
      average =
          ((base * (average ?? inCost)) + (inQty * inCost)) / totalQty;
    }
    stock += row.qtyBaseDelta;
  }
  return average;
}

/// Saldo utang pelanggan = jumlah ledger (SPEC §6.9). Positif = pelanggan
/// berutang, negatif = toko berutang/kelebihan bayar.
Future<int> debtBalanceOf(AppDatabase db, String customerId) async {
  final total = db.debtLedger.delta.sum();
  final query = db.selectOnly(db.debtLedger)
    ..addColumns([total])
    ..where(db.debtLedger.customerId.equals(customerId));
  final row = await query.getSingle();
  return row.read(total) ?? 0;
}

/// Menambah satu baris ledger stok beserta antrean sinkronnya.
///
/// Harus dipanggil di dalam `db.transaction(...)` agar baris dan outbox
/// tersimpan bersama (SPEC P1).
Future<void> addStockMovement(
  AppDatabase db, {
  required String id,
  required String storeId,
  required String productId,
  required int qtyBaseDelta,
  required MovementType type,
  required DateTime occurredAt,
  String? refType,
  String? refId,
  double? costPerBase,
  String? note,
  String? deviceId,
}) async {
  final at = occurredAt.toUtc();
  await db
      .into(db.stockMovements)
      .insert(
        StockMovementsCompanion.insert(
          id: id,
          storeId: storeId,
          productId: productId,
          qtyBaseDelta: qtyBaseDelta,
          type: type,
          occurredAt: at,
          refType: Value(refType),
          refId: Value(refId),
          costPerBase: Value(costPerBase),
          note: Value(note),
          deviceId: Value(deviceId),
        ),
      );

  await enqueueOutbox(
    db,
    table: 'stock_movements',
    rowId: id,
    op: 'insert',
    payload: {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'qty_base_delta': qtyBaseDelta,
      'type': const MovementTypeConverter().toSql(type),
      'ref_type': refType,
      'ref_id': refId,
      'cost_per_base': costPerBase,
      'occurred_at': at.toIso8601String(),
      'note': note,
      'device_id': deviceId,
    },
    at: at,
  );
}

/// Menambah satu baris ledger utang beserta antrean sinkronnya.
Future<void> addDebtEntry(
  AppDatabase db, {
  required String id,
  required String storeId,
  required String customerId,
  required int delta,
  required DebtType type,
  required DateTime occurredAt,
  String? refId,
  PayMethod? method,
  String? note,
  String? deviceId,
}) async {
  final at = occurredAt.toUtc();
  await db
      .into(db.debtLedger)
      .insert(
        DebtLedgerCompanion.insert(
          id: id,
          storeId: storeId,
          customerId: customerId,
          delta: delta,
          type: type,
          occurredAt: at,
          refId: Value(refId),
          method: Value(method),
          note: Value(note),
          deviceId: Value(deviceId),
        ),
      );

  await enqueueOutbox(
    db,
    table: 'debt_ledger',
    rowId: id,
    op: 'insert',
    payload: {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'delta': delta,
      'type': const DebtTypeConverter().toSql(type),
      'ref_id': refId,
      'method': method == null ? null : const PayMethodConverter().toSql(method),
      'occurred_at': at.toIso8601String(),
      'note': note,
      'device_id': deviceId,
    },
    at: at,
  );
}
