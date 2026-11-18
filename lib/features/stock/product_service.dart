import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';

/// Mengubah stok minimum produk (dipakai daftar "Perlu dibeli", SPEC §6.7).
Future<void> updateProductMinStock(
  AppDatabase db, {
  required String storeId,
  required String productId,
  required int minStockBase,
  DateTime? at,
}) async {
  if (minStockBase < 0) {
    throw ArgumentError('Stok minimum tidak boleh negatif.');
  }

  final now = (at ?? DateTime.now()).toUtc();

  await db.transaction(() async {
    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals(productId))).getSingleOrNull();
    if (product == null) {
      throw ArgumentError('Produk tidak ditemukan.');
    }
    if (product.minStockBase == minStockBase) return;

    await (db.update(db.products)..where((t) => t.id.equals(productId))).write(
      ProductsCompanion(
        minStockBase: Value(minStockBase),
        updatedAt: Value(now),
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
        'min_stock_base': minStockBase,
        'updated_at': now.toIso8601String(),
      },
      at: now,
    );
  });
}
