import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

/// Perubahan data produk yang dibutuhkan kasir.
class ProductService {
  ProductService(this.db, {required this.storeId, required this.deviceId});

  final AppDatabase db;
  final String storeId;
  final String deviceId;

  /// Menetapkan harga jual per satuan dan mencatat riwayat harga `sell`.
  ///
  /// Bila semua satuan jual sudah punya harga, tanda `needs_price_review`
  /// dilepas sehingga produk tidak lagi muncul di daftar "Perlu dicek".
  Future<void> setSellPrice({
    required String productId,
    required String unitId,
    required int price,
    DateTime? at,
  }) async {
    if (price < 0) {
      throw ArgumentError('harga jual tidak boleh negatif');
    }

    await db.transaction(() async {
      final unit =
          await (db.select(db.productUnits)
                ..where((t) => t.id.equals(unitId)))
              .getSingleOrNull();
      if (unit == null) {
        throw StateError('satuan $unitId tidak ditemukan');
      }
      if (unit.productId != productId) {
        throw ArgumentError('satuan bukan milik produk $productId');
      }

      final now = (at ?? DateTime.now()).toUtc();
      await (db.update(db.productUnits)
            ..where((t) => t.id.equals(unitId)))
          .write(
            ProductUnitsCompanion(
              sellPrice: Value(price),
              updatedAt: Value(now),
              deviceId: Value(deviceId),
            ),
          );
      await enqueueOutbox(
        db,
        table: 'product_units',
        rowId: unitId,
        op: 'update',
        payload: {
          'id': unitId,
          'store_id': storeId,
          'sell_price': price,
          'updated_at': now.toIso8601String(),
          'device_id': deviceId,
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
              productUnitId: unitId,
              kind: PriceKind.sell,
              price: price,
              effectiveAt: now,
              sourceRef: const Value('kasir:harga-jual'),
              createdAt: now,
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
          'product_unit_id': unitId,
          'kind': const PriceKindConverter().toSql(PriceKind.sell),
          'price': price,
          'effective_at': now.toIso8601String(),
          'source_ref': 'kasir:harga-jual',
          'created_at': now.toIso8601String(),
          'device_id': deviceId,
        },
        at: now,
      );

      final units =
          await (db.select(db.productUnits)
                ..where((t) => t.productId.equals(productId)))
              .get();
      final saleUnits = units.where((u) => u.isDefaultSale).toList();
      final complete =
          saleUnits.isNotEmpty && saleUnits.every((u) => u.sellPrice != null);
      if (!complete) return;

      final product =
          await (db.select(db.products)
                ..where((t) => t.id.equals(productId)))
              .getSingleOrNull();
      if (product == null || !product.needsPriceReview) return;

      await (db.update(db.products)
            ..where((t) => t.id.equals(productId)))
          .write(
            ProductsCompanion(
              needsPriceReview: const Value(false),
              updatedAt: Value(now),
              deviceId: Value(deviceId),
            ),
          );
      await enqueueOutbox(
        db,
        table: 'products',
        rowId: productId,
        op: 'update',
        payload: {
          'id': productId,
          'store_id': storeId,
          'needs_price_review': false,
          'updated_at': now.toIso8601String(),
          'device_id': deviceId,
        },
        at: now,
      );
    });
  }
}
