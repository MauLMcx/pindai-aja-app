import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';
import 'stock_math.dart';
import 'stock_queries.dart';

/// Satu baris yang diisi kasir di layar Barang Masuk.
class PurchaseLineInput {
  const PurchaseLineInput({
    required this.productId,
    required this.unitId,
    required this.qty,
    required this.unitCost,
  });

  final String productId;
  final String unitId;

  /// Jumlah dalam satuan yang dipilih (bukan satuan dasar).
  final int qty;

  /// Harga beli per satuan yang dipilih, rupiah bulat.
  final int unitCost;
}

/// Peringatan selisih harga beli dibanding pembelian sebelumnya (SPEC §6.2 KP).
class PriceChangeWarning {
  const PriceChangeWarning({
    required this.productName,
    required this.unitName,
    required this.oldPrice,
    required this.newPrice,
  });

  final String productName;
  final String unitName;
  final int oldPrice;
  final int newPrice;

  int get difference => newPrice - oldPrice;
  bool get isIncrease => newPrice > oldPrice;

  String get message {
    final arah = isIncrease ? 'naik' : 'turun';
    final diff = difference.abs();
    return '$productName ($unitName): harga $arah Rp $diff '
        '(Rp $oldPrice → Rp $newPrice)';
  }
}

class PurchaseSaveResult {
  const PurchaseSaveResult({
    required this.purchaseId,
    required this.total,
    required this.itemCount,
    required this.warnings,
  });

  final String purchaseId;
  final int total;
  final int itemCount;
  final List<PriceChangeWarning> warnings;
}

class _ResolvedLine {
  const _ResolvedLine({
    required this.productId,
    required this.productName,
    required this.unitId,
    required this.unitName,
    required this.qty,
    required this.unitCost,
    required this.qtyBase,
    required this.costPerBase,
    required this.amount,
  });

  final String productId;
  final String productName;
  final String unitId;
  final String unitName;
  final int qty;
  final int unitCost;
  final int qtyBase;
  final double costPerBase;
  final int amount;
}

String _iso(DateTime value) => value.toUtc().toIso8601String();

/// Menyimpan pembelian (barang masuk) dalam SATU transaksi bersama outbox.
///
/// Menghasilkan:
/// * baris `purchases` + `purchase_items`,
/// * mutasi stok `purchase_in` (satu per baris),
/// * baris `price_history` jenis `buy`,
/// * entri `outbox` untuk semua baris di atas.
Future<PurchaseSaveResult> recordPurchase(
  AppDatabase db, {
  required String storeId,
  String? supplierId,
  String? docNo,
  required DateTime purchasedAt,
  String? note,
  required List<PurchaseLineInput> lines,
  DateTime? at,
}) async {
  if (lines.isEmpty) {
    throw ArgumentError('Pembelian harus berisi minimal satu barang.');
  }

  final now = (at ?? DateTime.now()).toUtc();
  final purchasedAtUtc = purchasedAt.toUtc();
  final purchaseId = newId();
  final resolved = <_ResolvedLine>[];
  final warnings = <PriceChangeWarning>[];

  await db.transaction(() async {
    for (final line in lines) {
      if (line.qty <= 0) {
        throw ArgumentError('Jumlah barang harus lebih dari 0.');
      }
      if (line.unitCost < 0) {
        throw ArgumentError('Harga beli tidak boleh negatif.');
      }

      final unit = await (db.select(
        db.productUnits,
      )..where((t) => t.id.equals(line.unitId))).getSingleOrNull();
      if (unit == null) {
        throw ArgumentError('Satuan produk tidak ditemukan.');
      }
      if (unit.productId != line.productId) {
        throw ArgumentError('Satuan yang dipilih bukan milik produk tersebut.');
      }

      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(line.productId))).getSingleOrNull();
      if (product == null) {
        throw ArgumentError('Produk tidak ditemukan.');
      }

      final previous = await lastBuyPrice(db, unit.id);
      if (previous != null && previous != line.unitCost) {
        warnings.add(
          PriceChangeWarning(
            productName: product.name,
            unitName: unit.unitName,
            oldPrice: previous,
            newPrice: line.unitCost,
          ),
        );
      }

      resolved.add(
        _ResolvedLine(
          productId: product.id,
          productName: product.name,
          unitId: unit.id,
          unitName: unit.unitName,
          qty: line.qty,
          unitCost: line.unitCost,
          qtyBase: line.qty * unit.factorToBase,
          costPerBase: costPerBaseFrom(line.unitCost, unit.factorToBase),
          amount: line.qty * line.unitCost,
        ),
      );
    }

    final total = resolved.fold<int>(0, (sum, line) => sum + line.amount);

    await db
        .into(db.purchases)
        .insert(
          PurchasesCompanion.insert(
            id: purchaseId,
            storeId: storeId,
            supplierId: Value(supplierId),
            docNo: Value(docNo),
            purchasedAt: purchasedAtUtc,
            total: total,
            note: Value(note),
            createdAt: now,
            updatedAt: now,
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
        'purchased_at': _iso(purchasedAtUtc),
        'total': total,
        'note': note,
        'status': 'completed',
        'created_at': _iso(now),
        'updated_at': _iso(now),
      },
      at: now,
    );

    for (final line in resolved) {
      final itemId = newId();
      await db
          .into(db.purchaseItems)
          .insert(
            PurchaseItemsCompanion.insert(
              id: itemId,
              storeId: storeId,
              purchaseId: purchaseId,
              productId: line.productId,
              unitId: line.unitId,
              qty: line.qty,
              unitCost: line.unitCost,
              qtyBase: line.qtyBase,
              costPerBase: line.costPerBase,
              createdAt: now,
              updatedAt: now,
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
          'product_id': line.productId,
          'unit_id': line.unitId,
          'qty': line.qty,
          'unit_cost': line.unitCost,
          'qty_base': line.qtyBase,
          'cost_per_base': line.costPerBase,
          'created_at': _iso(now),
          'updated_at': _iso(now),
        },
        at: now,
      );

      final movementId = newId();
      await db
          .into(db.stockMovements)
          .insert(
            StockMovementsCompanion.insert(
              id: movementId,
              storeId: storeId,
              productId: line.productId,
              qtyBaseDelta: line.qtyBase,
              type: MovementType.purchaseIn,
              refType: const Value('purchase'),
              refId: Value(purchaseId),
              costPerBase: Value(line.costPerBase),
              occurredAt: purchasedAtUtc,
              note: Value(docNo),
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
          'type': 'purchase_in',
          'ref_type': 'purchase',
          'ref_id': purchaseId,
          'cost_per_base': line.costPerBase,
          'occurred_at': _iso(purchasedAtUtc),
          'note': docNo,
        },
        at: now,
      );

      final priceId = newId();
      await db
          .into(db.priceHistory)
          .insert(
            PriceHistoryCompanion.insert(
              id: priceId,
              storeId: storeId,
              productUnitId: line.unitId,
              kind: PriceKind.buy,
              price: line.unitCost,
              effectiveAt: purchasedAtUtc,
              sourceRef: Value(purchaseId),
              createdAt: now,
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
          'product_unit_id': line.unitId,
          'kind': 'buy',
          'price': line.unitCost,
          'effective_at': _iso(purchasedAtUtc),
          'source_ref': purchaseId,
        },
        at: now,
      );
    }
  });

  final total = resolved.fold<int>(0, (sum, line) => sum + line.amount);
  return PurchaseSaveResult(
    purchaseId: purchaseId,
    total: total,
    itemCount: resolved.length,
    warnings: warnings,
  );
}
