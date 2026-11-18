import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';
import 'stock_queries.dart';

String _iso(DateTime value) => value.toUtc().toIso8601String();

/// Satu baris retur yang diisi pengguna.
class ReturnLineInput {
  const ReturnLineInput({
    required this.productId,
    required this.unitId,
    required this.qty,
    this.amount = 0,
  });

  final String productId;
  final String unitId;

  /// Jumlah yang diretur dalam satuan dokumen asal.
  final int qty;

  /// Nominal refund untuk baris ini. `0` berarti dihitung otomatis
  /// secara proporsional dari nilai baris dokumen asal (retur penjualan).
  final int amount;
}

class ReturnSaveResult {
  const ReturnSaveResult({
    required this.returnId,
    required this.qtyBase,
    required this.amount,
  });

  final String returnId;
  final int qtyBase;
  final int amount;
}

/// Satu baris retur penjualan tanpa dokumen asal (pelanggan tidak membawa
/// struk). Harga jual diisi manual; HPP memakai rata-rata berjalan saat ini.
class StandaloneReturnLineInput {
  const StandaloneReturnLineInput({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.unitPrice,
    this.costPerBase,
  });

  final String productId;
  final String unitId;
  final int qty;
  final int unitPrice;

  /// Bila kosong, dihitung dari HPP rata-rata ledger saat retur disimpan.
  final double? costPerBase;
}

class _ResolvedReturnLine {
  const _ResolvedReturnLine({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.qtyBase,
    required this.amount,
    required this.costPerBase,
  });

  final String productId;
  final String unitId;
  final int qty;
  final int qtyBase;
  final int amount;
  final double? costPerBase;
}

class _DocLine {
  const _DocLine({
    required this.qtyBase,
    required this.returnedBase,
    required this.unitCost,
    required this.lineTotal,
    required this.costPerBase,
  });

  final int qtyBase;
  final int returnedBase;
  final int unitCost;
  final int lineTotal;
  final double? costPerBase;

  int get remainingBase => qtyBase - returnedBase;
}

Future<_DocLine?> _findPurchaseLine(
  AppDatabase db,
  String purchaseId,
  String productId,
  String unitId,
) async {
  final row = await db
      .customSelect(
        'select pi.qty_base, pi.unit_cost, pi.cost_per_base, '
        'coalesce((select sum(ri.qty_base) from return_items ri '
        '  join returns r on r.id = ri.return_id '
        '  where r.purchase_id = ? and r.deleted_at is null '
        '    and ri.deleted_at is null '
        '    and ri.product_id = pi.product_id '
        '    and ri.unit_id = pi.unit_id), 0) as returned_base '
        'from purchase_items pi '
        'where pi.purchase_id = ? and pi.product_id = ? and pi.unit_id = ? '
        '  and pi.deleted_at is null limit 1',
        variables: [
          Variable<String>(purchaseId),
          Variable<String>(purchaseId),
          Variable<String>(productId),
          Variable<String>(unitId),
        ],
        readsFrom: {db.purchaseItems, db.returnItems, db.returns},
      )
      .getSingleOrNull();
  if (row == null) return null;
  return _DocLine(
    qtyBase: row.read<int>('qty_base'),
    returnedBase: row.read<int>('returned_base'),
    unitCost: row.read<int>('unit_cost'),
    lineTotal: 0,
    costPerBase: row.readNullable<double>('cost_per_base'),
  );
}

Future<_DocLine?> _findSaleLine(
  AppDatabase db,
  String saleId,
  String productId,
  String unitId,
) async {
  final row = await db
      .customSelect(
        'select si.qty_base, si.line_total, si.cost_per_base, '
        'coalesce((select sum(ri.qty_base) from return_items ri '
        '  join returns r on r.id = ri.return_id '
        '  where r.sale_id = ? and r.deleted_at is null '
        '    and ri.deleted_at is null '
        '    and ri.product_id = si.product_id '
        '    and ri.unit_id = si.unit_id), 0) as returned_base '
        'from sale_items si '
        'where si.sale_id = ? and si.product_id = ? and si.unit_id = ? '
        '  and si.deleted_at is null limit 1',
        variables: [
          Variable<String>(saleId),
          Variable<String>(saleId),
          Variable<String>(productId),
          Variable<String>(unitId),
        ],
        readsFrom: {db.saleItems, db.returnItems, db.returns},
      )
      .getSingleOrNull();
  if (row == null) return null;
  return _DocLine(
    qtyBase: row.read<int>('qty_base'),
    returnedBase: row.read<int>('returned_base'),
    unitCost: 0,
    lineTotal: row.read<int>('line_total'),
    costPerBase: row.readNullable<double>('cost_per_base'),
  );
}

Future<int> _unitFactor(AppDatabase db, String unitId) async {
  final unit = await (db.select(
    db.productUnits,
  )..where((t) => t.id.equals(unitId))).getSingleOrNull();
  if (unit == null) {
    throw ArgumentError('Satuan produk tidak ditemukan.');
  }
  return unit.factorToBase;
}

/// Retur pembelian ke pemasok (SPEC §6.5): stok berkurang lewat mutasi
/// `purchase_return_out`. Utang ke pemasok di luar cakupan versi 1.
Future<ReturnSaveResult> recordPurchaseReturn(
  AppDatabase db, {
  required String storeId,
  required String purchaseId,
  required DateTime returnedAt,
  String? reason,
  required List<ReturnLineInput> lines,
  DateTime? at,
}) async {
  if (lines.isEmpty) {
    throw ArgumentError('Retur harus berisi minimal satu barang.');
  }

  final now = (at ?? DateTime.now()).toUtc();
  final returnedAtUtc = returnedAt.toUtc();

  return db.transaction(() async {
    final purchase = await (db.select(
      db.purchases,
    )..where((t) => t.id.equals(purchaseId))).getSingleOrNull();
    if (purchase == null || purchase.deletedAt != null) {
      throw ArgumentError('Dokumen pembelian tidak ditemukan.');
    }

    final resolved = <_ResolvedReturnLine>[];
    for (final line in lines) {
      if (line.qty <= 0) {
        throw ArgumentError('Jumlah retur harus lebih dari 0.');
      }
      final doc = await _findPurchaseLine(
        db,
        purchaseId,
        line.productId,
        line.unitId,
      );
      if (doc == null) {
        throw ArgumentError('Barang tersebut tidak ada di dokumen pembelian.');
      }
      final factor = await _unitFactor(db, line.unitId);
      final qtyBase = line.qty * factor;
      if (qtyBase > doc.remainingBase) {
        throw ArgumentError('Jumlah retur melebihi sisa yang belum diretur.');
      }
      resolved.add(
        _ResolvedReturnLine(
          productId: line.productId,
          unitId: line.unitId,
          qty: line.qty,
          qtyBase: qtyBase,
          amount: line.qty * doc.unitCost,
          costPerBase: doc.costPerBase,
        ),
      );
    }

    final returnId = newId();
    final totalQtyBase = resolved.fold<int>(0, (sum, l) => sum + l.qtyBase);
    final totalAmount = resolved.fold<int>(0, (sum, l) => sum + l.amount);

    // Retur pembelian tidak memberi refund ke pemasok pada versi 1.
    await _insertReturn(
      db,
      returnId: returnId,
      storeId: storeId,
      kind: ReturnKind.purchase,
      purchaseId: purchaseId,
      saleId: null,
      customerId: null,
      returnedAt: returnedAtUtc,
      refundMethod: null,
      refundTotal: 0,
      reason: reason,
      now: now,
    );

    for (final line in resolved) {
      await _insertReturnItem(
        db,
        returnId: returnId,
        storeId: storeId,
        line: line,
        now: now,
      );
      final movementId = newId();
      await db
          .into(db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: movementId,
              storeId: storeId,
              productId: line.productId,
              qtyBaseDelta: -line.qtyBase,
              type: MovementType.purchaseReturnOut,
              refType: const Value('return'),
              refId: Value(returnId),
              costPerBase: Value(line.costPerBase),
              occurredAt: returnedAtUtc,
              note: Value(reason),
            ),
          );
      await enqueueOutbox(
        db,
        table: 'stock_movements',
        rowId: movementId,
        op: 'insert',
        payload: {
          'id': movementId,
          'store_id': storeId,
          'product_id': line.productId,
          'qty_base_delta': -line.qtyBase,
          'type': 'purchase_return_out',
          'ref_type': 'return',
          'ref_id': returnId,
          'cost_per_base': line.costPerBase,
          'occurred_at': _iso(returnedAtUtc),
          'note': reason,
        },
        at: now,
      );
    }

    return ReturnSaveResult(
      returnId: returnId,
      qtyBase: totalQtyBase,
      amount: totalAmount,
    );
  });
}

/// Retur penjualan (SPEC §6.5): stok kembali lewat mutasi `return_in` dengan
/// biaya sesuai snapshot `cost_per_base` baris penjualan asal.
Future<ReturnSaveResult> recordSaleReturn(
  AppDatabase db, {
  required String storeId,
  required String saleId,
  required DateTime returnedAt,
  String? customerId,
  PayMethod? refundMethod,
  String? reason,
  required List<ReturnLineInput> lines,
  DateTime? at,
}) async {
  if (lines.isEmpty) {
    throw ArgumentError('Retur harus berisi minimal satu barang.');
  }

  final now = (at ?? DateTime.now()).toUtc();
  final returnedAtUtc = returnedAt.toUtc();

  return db.transaction(() async {
    final sale = await (db.select(
      db.sales,
    )..where((t) => t.id.equals(saleId))).getSingleOrNull();
    if (sale == null || sale.deletedAt != null) {
      throw ArgumentError('Transaksi penjualan tidak ditemukan.');
    }
    if (sale.status != SaleStatus.completed) {
      throw StateError('Hanya transaksi berstatus selesai yang bisa diretur.');
    }

    final resolved = <_ResolvedReturnLine>[];
    for (final line in lines) {
      if (line.qty <= 0) {
        throw ArgumentError('Jumlah retur harus lebih dari 0.');
      }
      if (line.amount < 0) {
        throw ArgumentError('Nominal refund tidak boleh negatif.');
      }
      final doc = await _findSaleLine(db, saleId, line.productId, line.unitId);
      if (doc == null) {
        throw ArgumentError(
          'Barang tersebut tidak ada di transaksi penjualan.',
        );
      }
      final factor = await _unitFactor(db, line.unitId);
      final qtyBase = line.qty * factor;
      if (qtyBase > doc.remainingBase) {
        throw ArgumentError('Jumlah retur melebihi sisa yang belum diretur.');
      }

      final amount = line.amount > 0
          ? line.amount
          : ((doc.lineTotal * qtyBase) / (doc.qtyBase == 0 ? 1 : doc.qtyBase))
                .round();
      final cost = doc.costPerBase ?? 0.0;
      resolved.add(
        _ResolvedReturnLine(
          productId: line.productId,
          unitId: line.unitId,
          qty: line.qty,
          qtyBase: qtyBase,
          amount: amount,
          costPerBase: cost,
        ),
      );
    }

    final returnId = newId();
    final totalQtyBase = resolved.fold<int>(0, (sum, l) => sum + l.qtyBase);
    final refundTotal = resolved.fold<int>(0, (sum, l) => sum + l.amount);

    await _insertReturn(
      db,
      returnId: returnId,
      storeId: storeId,
      kind: ReturnKind.sale,
      purchaseId: null,
      saleId: saleId,
      customerId: customerId ?? sale.customerId,
      returnedAt: returnedAtUtc,
      refundMethod: refundMethod,
      refundTotal: refundTotal,
      reason: reason,
      now: now,
    );

    for (final line in resolved) {
      await _insertReturnItem(
        db,
        returnId: returnId,
        storeId: storeId,
        line: line,
        now: now,
      );
      await _writeReturnInMovement(
        db,
        storeId: storeId,
        returnId: returnId,
        line: line,
        returnedAt: returnedAtUtc,
        reason: reason,
        now: now,
      );
    }

    // Refund lewat pengurangan utang pelanggan (SPEC §6.5).
    final debtCustomer = customerId ?? sale.customerId;
    if (refundMethod == PayMethod.credit &&
        debtCustomer != null &&
        refundTotal > 0) {
      await _writeCreditRefund(
        db,
        storeId: storeId,
        customerId: debtCustomer,
        returnId: returnId,
        amount: refundTotal,
        returnedAt: returnedAtUtc,
        reason: reason,
        now: now,
      );
    }

    return ReturnSaveResult(
      returnId: returnId,
      qtyBase: totalQtyBase,
      amount: refundTotal,
    );
  });
}

/// Retur penjualan tanpa dokumen asal (SPEC §6.5: "pilih transaksi asal atau
/// tanpa transaksi"). Harga jual diisi manual; HPP memakai rata-rata berjalan
/// saat retur disimpan karena tidak ada snapshot baris penjualan.
Future<ReturnSaveResult> recordSaleReturnWithoutInvoice(
  AppDatabase db, {
  required String storeId,
  required DateTime returnedAt,
  String? customerId,
  PayMethod? refundMethod,
  String? reason,
  required List<StandaloneReturnLineInput> lines,
  DateTime? at,
}) async {
  if (lines.isEmpty) {
    throw ArgumentError('Retur harus berisi minimal satu barang.');
  }

  final now = (at ?? DateTime.now()).toUtc();
  final returnedAtUtc = returnedAt.toUtc();

  return db.transaction(() async {
    final resolved = <_ResolvedReturnLine>[];
    for (final line in lines) {
      if (line.qty <= 0) {
        throw ArgumentError('Jumlah retur harus lebih dari 0.');
      }
      if (line.unitPrice < 0) {
        throw ArgumentError('Harga jual tidak boleh negatif.');
      }
      final factor = await _unitFactor(db, line.unitId);
      final qtyBase = line.qty * factor;
      final average =
          line.costPerBase ?? await movingAverageCostBase(db, line.productId);
      resolved.add(
        _ResolvedReturnLine(
          productId: line.productId,
          unitId: line.unitId,
          qty: line.qty,
          qtyBase: qtyBase,
          amount: line.qty * line.unitPrice,
          costPerBase: average,
        ),
      );
    }

    final returnId = newId();
    final totalQtyBase = resolved.fold<int>(0, (sum, l) => sum + l.qtyBase);
    final refundTotal = resolved.fold<int>(0, (sum, l) => sum + l.amount);

    await _insertReturn(
      db,
      returnId: returnId,
      storeId: storeId,
      kind: ReturnKind.sale,
      purchaseId: null,
      saleId: null,
      customerId: customerId,
      returnedAt: returnedAtUtc,
      refundMethod: refundMethod,
      refundTotal: refundTotal,
      reason: reason,
      now: now,
    );

    for (final line in resolved) {
      await _insertReturnItem(
        db,
        returnId: returnId,
        storeId: storeId,
        line: line,
        now: now,
      );
      await _writeReturnInMovement(
        db,
        storeId: storeId,
        returnId: returnId,
        line: line,
        returnedAt: returnedAtUtc,
        reason: reason,
        now: now,
      );
    }

    if (refundMethod == PayMethod.credit &&
        customerId != null &&
        refundTotal > 0) {
      await _writeCreditRefund(
        db,
        storeId: storeId,
        customerId: customerId,
        returnId: returnId,
        amount: refundTotal,
        returnedAt: returnedAtUtc,
        reason: reason,
        now: now,
      );
    }

    return ReturnSaveResult(
      returnId: returnId,
      qtyBase: totalQtyBase,
      amount: refundTotal,
    );
  });
}

Future<void> _writeReturnInMovement(
  AppDatabase db, {
  required String storeId,
  required String returnId,
  required _ResolvedReturnLine line,
  required DateTime returnedAt,
  required String? reason,
  required DateTime now,
}) async {
  final movementId = newId();
  await db
      .into(db.stockMovements)
      .insert(
        StockMovementsCompanion.insert(
          id: movementId,
          storeId: storeId,
          productId: line.productId,
          qtyBaseDelta: line.qtyBase,
          type: MovementType.returnIn,
          refType: const Value('return'),
          refId: Value(returnId),
          costPerBase: Value(line.costPerBase),
          occurredAt: returnedAt,
          note: Value(reason),
        ),
      );
  await enqueueOutbox(
    db,
    table: 'stock_movements',
    rowId: movementId,
    op: 'insert',
    payload: {
      'id': movementId,
      'store_id': storeId,
      'product_id': line.productId,
      'qty_base_delta': line.qtyBase,
      'type': 'return_in',
      'ref_type': 'return',
      'ref_id': returnId,
      'cost_per_base': line.costPerBase,
      'occurred_at': _iso(returnedAt),
      'note': reason,
    },
    at: now,
  );
}

Future<void> _writeCreditRefund(
  AppDatabase db, {
  required String storeId,
  required String customerId,
  required String returnId,
  required int amount,
  required DateTime returnedAt,
  required String? reason,
  required DateTime now,
}) async {
  final debtId = newId();
  await db
      .into(db.debtLedger)
      .insert(
        DebtLedgerCompanion.insert(
          id: debtId,
          storeId: storeId,
          customerId: customerId,
          delta: -amount,
          type: DebtType.returnOffset,
          refId: Value(returnId),
          occurredAt: returnedAt,
          note: Value(reason),
        ),
      );
  await enqueueOutbox(
    db,
    table: 'debt_ledger',
    rowId: debtId,
    op: 'insert',
    payload: {
      'id': debtId,
      'store_id': storeId,
      'customer_id': customerId,
      'delta': -amount,
      'type': 'return_offset',
      'ref_id': returnId,
      'method': 'credit',
      'occurred_at': _iso(returnedAt),
      'note': reason,
    },
    at: now,
  );
}

Future<void> _insertReturn(
  AppDatabase db, {
  required String returnId,
  required String storeId,
  required ReturnKind kind,
  required String? purchaseId,
  required String? saleId,
  required String? customerId,
  required DateTime returnedAt,
  required PayMethod? refundMethod,
  required int refundTotal,
  required String? reason,
  required DateTime now,
}) async {
  await db
      .into(db.returns)
      .insert(
        ReturnsCompanion.insert(
          id: returnId,
          storeId: storeId,
          kind: kind,
          saleId: Value(saleId),
          purchaseId: Value(purchaseId),
          customerId: Value(customerId),
          returnedAt: returnedAt,
          refundMethod: Value(refundMethod),
          refundTotal: Value(refundTotal),
          reason: Value(reason),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await enqueueOutbox(
    db,
    table: 'returns',
    rowId: returnId,
    op: 'insert',
    payload: {
      'id': returnId,
      'store_id': storeId,
      'kind': kind.name,
      'sale_id': saleId,
      'purchase_id': purchaseId,
      'customer_id': customerId,
      'returned_at': _iso(returnedAt),
      'refund_method': refundMethod?.name,
      'refund_total': refundTotal,
      'reason': reason,
      'created_at': _iso(now),
      'updated_at': _iso(now),
    },
    at: now,
  );
}

Future<void> _insertReturnItem(
  AppDatabase db, {
  required String returnId,
  required String storeId,
  required _ResolvedReturnLine line,
  required DateTime now,
}) async {
  final itemId = newId();
  await db
      .into(db.returnItems)
      .insert(
        ReturnItemsCompanion.insert(
          id: itemId,
          storeId: storeId,
          returnId: returnId,
          productId: line.productId,
          unitId: line.unitId,
          qty: line.qty,
          qtyBase: line.qtyBase,
          amount: line.amount,
          costPerBase: Value(line.costPerBase),
          createdAt: now,
          updatedAt: now,
        ),
      );
  await enqueueOutbox(
    db,
    table: 'return_items',
    rowId: itemId,
    op: 'insert',
    payload: {
      'id': itemId,
      'store_id': storeId,
      'return_id': returnId,
      'product_id': line.productId,
      'unit_id': line.unitId,
      'qty': line.qty,
      'qty_base': line.qtyBase,
      'amount': line.amount,
      'cost_per_base': line.costPerBase,
      'created_at': _iso(now),
      'updated_at': _iso(now),
    },
    at: now,
  );
}
