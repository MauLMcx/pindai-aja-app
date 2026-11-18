import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/ledger.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

class ReturnItemInput {
  const ReturnItemInput({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.amount,
    this.costPerBase,
  });

  final String productId;
  final String unitId;
  final int qty;

  /// Nilai rupiah yang dikembalikan untuk baris ini.
  final int amount;
  final double? costPerBase;
}

class ReturnResult {
  const ReturnResult({
    required this.row,
    required this.refundTotal,
    required this.stockDeltaBase,
  });

  final Return row;
  final int refundTotal;
  final int stockDeltaBase;
}

/// Retur penjualan dan pembelian (SPEC §6.5). Ledger stok tetap append-only.
class ReturnService {
  ReturnService(this.db, {required this.storeId, required this.deviceId});

  final AppDatabase db;
  final String storeId;
  final String deviceId;

  Future<ReturnResult> returnSale({
    String? saleId,
    String? customerId,
    required List<ReturnItemInput> items,
    PayMethod? refundMethod,
    int? refundTotal,
    String? reason,
    DateTime? returnedAt,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('retur harus punya minimal satu item');
    }

    return db.transaction(() async {
      final at = (returnedAt ?? DateTime.now()).toUtc();
      final returnId = newId();
      final prepared = <_PreparedReturnLine>[];
      var total = 0;

      for (final item in items) {
        if (item.qty <= 0) {
          throw ArgumentError('jumlah retur harus lebih dari 0');
        }
        if (item.amount < 0) {
          throw ArgumentError('nilai retur tidak boleh negatif');
        }

        final unit =
            await (db.select(db.productUnits)
                  ..where((t) => t.id.equals(item.unitId)))
                .getSingleOrNull();
        if (unit == null) {
          throw StateError('satuan ${item.unitId} tidak ditemukan');
        }
        if (unit.productId != item.productId) {
          throw ArgumentError('satuan bukan milik produk ${item.productId}');
        }

        double? cost = item.costPerBase;
        if (cost == null && saleId != null) {
          final original =
              await (db.select(db.saleItems)
                    ..where(
                      (t) =>
                          t.saleId.equals(saleId) &
                          t.productId.equals(item.productId) &
                          t.unitId.equals(item.unitId),
                    )
                    ..limit(1))
                  .getSingleOrNull();
          cost = original?.costPerBase;
        }

        final qtyBase = item.qty * unit.factorToBase;
        total += item.amount;
        prepared.add(
          _PreparedReturnLine(
            item: item,
            qtyBase: qtyBase,
            costPerBase: cost,
          ),
        );
      }

      final refund = refundTotal ?? total;
      if (refund < 0) {
        throw ArgumentError('nilai refund tidak boleh negatif');
      }
      if (refundMethod == PayMethod.credit && customerId == null) {
        throw StateError('refund kredit membutuhkan pelanggan');
      }

      await db
          .into(db.returns)
          .insert(
            ReturnsCompanion.insert(
              id: returnId,
              storeId: storeId,
              kind: ReturnKind.sale,
              saleId: Value(saleId),
              customerId: Value(customerId),
              returnedAt: at,
              refundMethod: Value(refundMethod),
              refundTotal: Value(refund),
              reason: Value(reason),
              createdAt: at,
              updatedAt: at,
              deviceId: Value(deviceId),
            ),
          );

      await _enqueueReturn(
        returnId: returnId,
        kind: ReturnKind.sale,
        saleId: saleId,
        customerId: customerId,
        refundMethod: refundMethod,
        refundTotal: refund,
        reason: reason,
        at: at,
      );

      var stockDelta = 0;
      for (final line in prepared) {
        final item = line.item;
        final itemId = newId();

        await db
            .into(db.returnItems)
            .insert(
              ReturnItemsCompanion.insert(
                id: itemId,
                storeId: storeId,
                returnId: returnId,
                productId: item.productId,
                unitId: item.unitId,
                qty: item.qty,
                qtyBase: line.qtyBase,
                amount: item.amount,
                costPerBase: Value(line.costPerBase),
                createdAt: at,
                updatedAt: at,
                deviceId: Value(deviceId),
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
            'product_id': item.productId,
            'unit_id': item.unitId,
            'qty': item.qty,
            'qty_base': line.qtyBase,
            'amount': item.amount,
            'cost_per_base': line.costPerBase,
            'created_at': at.toIso8601String(),
            'updated_at': at.toIso8601String(),
            'device_id': deviceId,
          },
          at: at,
        );

        await addStockMovement(
          db,
          id: newId(),
          storeId: storeId,
          productId: item.productId,
          qtyBaseDelta: line.qtyBase,
          type: MovementType.returnIn,
          occurredAt: at,
          refType: 'return',
          refId: returnId,
          costPerBase: line.costPerBase,
          deviceId: deviceId,
        );
        stockDelta += line.qtyBase;
      }

      if (refundMethod == PayMethod.credit &&
          customerId != null &&
          refund > 0) {
        await addDebtEntry(
          db,
          id: newId(),
          storeId: storeId,
          customerId: customerId,
          delta: -refund,
          type: DebtType.returnOffset,
          occurredAt: at,
          refId: returnId,
          deviceId: deviceId,
        );
      }

      final row =
          await (db.select(db.returns)..where((t) => t.id.equals(returnId)))
              .getSingle();
      return ReturnResult(
        row: row,
        refundTotal: refund,
        stockDeltaBase: stockDelta,
      );
    });
  }

  Future<ReturnResult> returnPurchase({
    String? purchaseId,
    required List<ReturnItemInput> items,
    String? reason,
    DateTime? returnedAt,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('retur harus punya minimal satu item');
    }

    return db.transaction(() async {
      final at = (returnedAt ?? DateTime.now()).toUtc();
      final returnId = newId();
      final prepared = <_PreparedReturnLine>[];
      var total = 0;

      for (final item in items) {
        if (item.qty <= 0) {
          throw ArgumentError('jumlah retur harus lebih dari 0');
        }
        if (item.amount < 0) {
          throw ArgumentError('nilai retur tidak boleh negatif');
        }

        final unit =
            await (db.select(db.productUnits)
                  ..where((t) => t.id.equals(item.unitId)))
                .getSingleOrNull();
        if (unit == null) {
          throw StateError('satuan ${item.unitId} tidak ditemukan');
        }
        if (unit.productId != item.productId) {
          throw ArgumentError('satuan bukan milik produk ${item.productId}');
        }

        double? cost = item.costPerBase;
        if (cost == null && purchaseId != null) {
          final original =
              await (db.select(db.purchaseItems)
                    ..where(
                      (t) =>
                          t.purchaseId.equals(purchaseId) &
                          t.productId.equals(item.productId) &
                          t.unitId.equals(item.unitId),
                    )
                    ..limit(1))
                  .getSingleOrNull();
          cost = original?.costPerBase;
        }

        total += item.amount;
        prepared.add(
          _PreparedReturnLine(
            item: item,
            qtyBase: item.qty * unit.factorToBase,
            costPerBase: cost,
          ),
        );
      }

      await db
          .into(db.returns)
          .insert(
            ReturnsCompanion.insert(
              id: returnId,
              storeId: storeId,
              kind: ReturnKind.purchase,
              purchaseId: Value(purchaseId),
              returnedAt: at,
              refundTotal: Value(total),
              reason: Value(reason),
              createdAt: at,
              updatedAt: at,
              deviceId: Value(deviceId),
            ),
          );

      await _enqueueReturn(
        returnId: returnId,
        kind: ReturnKind.purchase,
        purchaseId: purchaseId,
        refundTotal: total,
        reason: reason,
        at: at,
      );

      var stockDelta = 0;
      for (final line in prepared) {
        final item = line.item;
        final itemId = newId();
        await db
            .into(db.returnItems)
            .insert(
              ReturnItemsCompanion.insert(
                id: itemId,
                storeId: storeId,
                returnId: returnId,
                productId: item.productId,
                unitId: item.unitId,
                qty: item.qty,
                qtyBase: line.qtyBase,
                amount: item.amount,
                costPerBase: Value(line.costPerBase),
                createdAt: at,
                updatedAt: at,
                deviceId: Value(deviceId),
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
            'product_id': item.productId,
            'unit_id': item.unitId,
            'qty': item.qty,
            'qty_base': line.qtyBase,
            'amount': item.amount,
            'cost_per_base': line.costPerBase,
            'created_at': at.toIso8601String(),
            'updated_at': at.toIso8601String(),
            'device_id': deviceId,
          },
          at: at,
        );

        await addStockMovement(
          db,
          id: newId(),
          storeId: storeId,
          productId: item.productId,
          qtyBaseDelta: -line.qtyBase,
          type: MovementType.purchaseReturnOut,
          occurredAt: at,
          refType: 'return',
          refId: returnId,
          costPerBase: line.costPerBase,
          deviceId: deviceId,
        );
        stockDelta -= line.qtyBase;
      }

      final row =
          await (db.select(db.returns)..where((t) => t.id.equals(returnId)))
              .getSingle();
      return ReturnResult(
        row: row,
        refundTotal: total,
        stockDeltaBase: stockDelta,
      );
    });
  }

  Future<void> _enqueueReturn({
    required String returnId,
    required ReturnKind kind,
    String? saleId,
    String? purchaseId,
    String? customerId,
    PayMethod? refundMethod,
    required int refundTotal,
    String? reason,
    required DateTime at,
  }) {
    return enqueueOutbox(
      db,
      table: 'returns',
      rowId: returnId,
      op: 'insert',
      payload: {
        'id': returnId,
        'store_id': storeId,
        'kind': const ReturnKindConverter().toSql(kind),
        'sale_id': saleId,
        'purchase_id': purchaseId,
        'customer_id': customerId,
        'returned_at': at.toIso8601String(),
        'refund_method': refundMethod == null
            ? null
            : const PayMethodConverter().toSql(refundMethod),
        'refund_total': refundTotal,
        'reason': reason,
        'created_at': at.toIso8601String(),
        'updated_at': at.toIso8601String(),
        'device_id': deviceId,
      },
      at: at,
    );
  }
}

class _PreparedReturnLine {
  const _PreparedReturnLine({
    required this.item,
    required this.qtyBase,
    required this.costPerBase,
  });

  final ReturnItemInput item;
  final int qtyBase;
  final double? costPerBase;
}
