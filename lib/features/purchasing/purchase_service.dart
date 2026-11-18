import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/ledger.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

class PurchaseItemInput {
  const PurchaseItemInput({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.unitCost,
  });

  final String productId;
  final String unitId;
  final int qty;

  /// Harga beli per satuan yang dipilih (rupiah).
  final int unitCost;
}

class PurchaseResult {
  const PurchaseResult({
    required this.purchase,
    required this.total,
    required this.priceWarnings,
  });

  final Purchase purchase;
  final int total;

  /// Peringatan harga beli naik dibanding pembelian sebelumnya (SPEC §6.2).
  final List<String> priceWarnings;
}

/// Barang masuk (SPEC §6.2): mutasi `purchase_in`, riwayat harga `buy`, dan
/// rata-rata HPP dihitung dari ledger.
class PurchaseService {
  PurchaseService(
    this.db, {
    required this.storeId,
    required this.deviceId,
  });

  final AppDatabase db;
  final String storeId;
  final String deviceId;

  Future<PurchaseResult> create({
    String? supplierId,
    String? docNo,
    required List<PurchaseItemInput> items,
    DateTime? purchasedAt,
    String? note,
  }) async {
    if (items.isEmpty) {
      throw ArgumentError('pembelian harus punya minimal satu item');
    }

    return db.transaction(() async {
      final at = (purchasedAt ?? DateTime.now()).toUtc();
      final purchaseId = newId();
      var total = 0;
      final warnings = <String>[];
      final prepared = <_PreparedPurchaseLine>[];

      for (final item in items) {
        if (item.qty <= 0) {
          throw ArgumentError('jumlah pembelian harus lebih dari 0');
        }
        if (item.unitCost < 0) {
          throw ArgumentError('harga beli tidak boleh negatif');
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

        final lastBuy =
            await (db.select(db.priceHistory)
                  ..where(
                    (t) =>
                        t.productUnitId.equals(item.unitId) &
                        t.kind.equalsValue(PriceKind.buy),
                  )
                  ..orderBy([(t) => OrderingTerm.desc(t.effectiveAt)])
                  ..limit(1))
                .getSingleOrNull();
        if (lastBuy != null && item.unitCost > lastBuy.price) {
          warnings.add(
            'Harga beli naik: ${lastBuy.price} → ${item.unitCost} '
            '(satuan ${unit.unitName})',
          );
        }

        final qtyBase = item.qty * unit.factorToBase;
        total += item.qty * item.unitCost;
        prepared.add(
          _PreparedPurchaseLine(
            item: item,
            qtyBase: qtyBase,
            costPerBase: item.unitCost / unit.factorToBase,
          ),
        );
      }

      await db
          .into(db.purchases)
          .insert(
            PurchasesCompanion.insert(
              id: purchaseId,
              storeId: storeId,
              supplierId: Value(supplierId),
              docNo: Value(docNo),
              purchasedAt: at,
              total: total,
              note: Value(note),
              createdAt: at,
              updatedAt: at,
              deviceId: Value(deviceId),
            ),
          );

      await enqueueOutbox(
        db,
        table: 'purchases',
        rowId: purchaseId,
        op: 'insert',
        payload: {
          'id': purchaseId,
          'store_id': storeId,
          'supplier_id': supplierId,
          'doc_no': docNo,
          'purchased_at': at.toIso8601String(),
          'total': total,
          'note': note,
          'status': 'completed',
          'created_at': at.toIso8601String(),
          'updated_at': at.toIso8601String(),
          'device_id': deviceId,
        },
        at: at,
      );

      for (final line in prepared) {
        final item = line.item;
        final itemId = newId();

        await db
            .into(db.purchaseItems)
            .insert(
              PurchaseItemsCompanion.insert(
                id: itemId,
                storeId: storeId,
                purchaseId: purchaseId,
                productId: item.productId,
                unitId: item.unitId,
                qty: item.qty,
                unitCost: item.unitCost,
                qtyBase: line.qtyBase,
                costPerBase: line.costPerBase,
                createdAt: at,
                updatedAt: at,
                deviceId: Value(deviceId),
              ),
            );

        await enqueueOutbox(
          db,
          table: 'purchase_items',
          rowId: itemId,
          op: 'insert',
          payload: {
            'id': itemId,
            'store_id': storeId,
            'purchase_id': purchaseId,
            'product_id': item.productId,
            'unit_id': item.unitId,
            'qty': item.qty,
            'unit_cost': item.unitCost,
            'qty_base': line.qtyBase,
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
          type: MovementType.purchaseIn,
          occurredAt: at,
          refType: 'purchase',
          refId: purchaseId,
          costPerBase: line.costPerBase,
          deviceId: deviceId,
        );

        final priceId = newId();
        await db
            .into(db.priceHistory)
            .insert(
              PriceHistoryCompanion.insert(
                id: priceId,
                storeId: storeId,
                productUnitId: item.unitId,
                kind: PriceKind.buy,
                price: item.unitCost,
                effectiveAt: at,
                createdAt: at,
                deviceId: Value(deviceId),
              ),
            );

        await enqueueOutbox(
          db,
          table: 'price_history',
          rowId: priceId,
          op: 'insert',
          payload: {
            'id': priceId,
            'store_id': storeId,
            'product_unit_id': item.unitId,
            'kind': const PriceKindConverter().toSql(PriceKind.buy),
            'price': item.unitCost,
            'effective_at': at.toIso8601String(),
            'created_at': at.toIso8601String(),
            'device_id': deviceId,
          },
          at: at,
        );
      }

      final purchase =
          await (db.select(db.purchases)
                ..where((t) => t.id.equals(purchaseId)))
              .getSingle();

      return PurchaseResult(
        purchase: purchase,
        total: total,
        priceWarnings: warnings,
      );
    });
  }
}

class _PreparedPurchaseLine {
  const _PreparedPurchaseLine({
    required this.item,
    required this.qtyBase,
    required this.costPerBase,
  });

  final PurchaseItemInput item;
  final int qtyBase;
  final double costPerBase;
}
