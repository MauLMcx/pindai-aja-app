import 'package:drift/drift.dart';

import '../../core/db/app_database.dart';
import '../../core/db/outbox_writer.dart';
import '../../core/ids.dart';

String _iso(DateTime value) => value.toUtc().toIso8601String();

/// Menyimpan perubahan lokasi rak (SPEC §6.3).
///
/// Lokasi baru disimpan di `products.shelf_location`, sedangkan riwayatnya
/// masuk ke `putaway_log` yang append-only. Keduanya plus outbox ditulis dalam
/// satu transaksi.
///
/// Mengembalikan `true` bila lokasi benar-benar berubah.
Future<bool> moveProductToShelf(
  AppDatabase db, {
  required String storeId,
  required String productId,
  required String? location,
  DateTime? at,
}) async {
  final now = (at ?? DateTime.now()).toUtc();
  final normalized = (location == null || location.trim().isEmpty)
      ? null
      : location.trim();

  return db.transaction(() async {
    final product = await (db.select(
      db.products,
    )..where((t) => t.id.equals(productId))).getSingleOrNull();
    if (product == null) {
      throw ArgumentError('Produk tidak ditemukan.');
    }
    if (product.deletedAt != null) {
      throw ArgumentError('Produk sudah dihapus.');
    }

    final previous = product.shelfLocation;
    if (previous == normalized) return false;

    await (db.update(db.products)..where((t) => t.id.equals(productId))).write(
      ProductsCompanion(
        shelfLocation: Value(normalized),
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
        'shelf_location': normalized,
        'updated_at': _iso(now),
      },
      at: now,
    );

    final logId = newId();
    await db
        .into(db.putawayLog)
        .insert(
          PutawayLogCompanion.insert(
            id: logId,
            storeId: storeId,
            productId: productId,
            fromLocation: Value(previous),
            toLocation: Value(normalized),
            occurredAt: now,
          ),
        );
    await enqueueOutbox(
      db,
      table: 'putaway_log',
      rowId: logId,
      op: 'insert',
      payload: {
        'id': logId,
        'store_id': storeId,
        'product_id': productId,
        'from_location': previous,
        'to_location': normalized,
        'occurred_at': _iso(now),
      },
      at: now,
    );

    return true;
  });
}
