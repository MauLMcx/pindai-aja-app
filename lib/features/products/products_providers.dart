import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/db/app_database.dart';
import '../../core/db/database_provider.dart';
import '../../core/store/local_store.dart';

/// Toko yang dipakai aplikasi saat ini (satu toko lokal sampai Tahap 3).
final localStoreProvider = FutureProvider<Store>((ref) async {
  final db = ref.watch(appDatabaseProvider);
  return ensureLocalStore(db);
});

/// Baris daftar produk: data produk + pemasok + satuan beli + harga beli + stok.
class ProductListItem {
  const ProductListItem({
    required this.id,
    required this.name,
    required this.baseUnit,
    required this.needsPriceReview,
    required this.stockBase,
    this.brand,
    this.variant,
    this.supplierName,
    this.unitName,
    this.unitFactor,
    this.buyPrice,
  });

  final String id;
  final String name;
  final String baseUnit;
  final bool needsPriceReview;
  final int stockBase;
  final String? brand;
  final String? variant;
  final String? supplierName;
  final String? unitName;
  final int? unitFactor;
  final int? buyPrice;
}

/// Produk aktif yang belum dihapus, lengkap dengan harga beli terakhir.
final productListProvider = StreamProvider<List<ProductListItem>>((ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final store = await ref.watch(localStoreProvider.future);
  yield* watchProductList(db, store.id);
});

Stream<List<ProductListItem>> watchProductList(AppDatabase db, String storeId) {
  return db
      .customSelect(
        '''
        SELECT p.id AS id,
               p.name AS name,
               p.brand AS brand,
               p.variant AS variant,
               p.base_unit AS base_unit,
               p.needs_price_review AS needs_price_review,
               s.name AS supplier_name,
               pu.unit_name AS unit_name,
               pu.factor_to_base AS unit_factor,
               (SELECT ph.price
                  FROM price_history ph
                 WHERE ph.product_unit_id = pu.id AND ph.kind = 'buy'
                 ORDER BY ph.effective_at DESC, ph.created_at DESC
                 LIMIT 1) AS buy_price,
               (SELECT COALESCE(SUM(sm.qty_base_delta), 0)
                  FROM stock_movements sm
                 WHERE sm.product_id = p.id AND sm.store_id = p.store_id) AS stock_base
          FROM products p
          LEFT JOIN suppliers s ON s.id = p.main_supplier_id
          LEFT JOIN product_units pu
                 ON pu.product_id = p.id AND pu.is_default_purchase = 1
         WHERE p.store_id = ? AND p.deleted_at IS NULL
         ORDER BY p.name COLLATE NOCASE, p.variant COLLATE NOCASE
        ''',
        variables: [Variable.withString(storeId)],
        readsFrom: {
          db.products,
          db.suppliers,
          db.productUnits,
          db.priceHistory,
          db.stockMovements,
        },
      )
      .watch()
      .map(
        (rows) => rows
            .map(
              (row) => ProductListItem(
                id: row.read<String>('id'),
                name: row.read<String>('name'),
                baseUnit: row.read<String>('base_unit'),
                needsPriceReview: row.read<int>('needs_price_review') != 0,
                stockBase: row.read<int>('stock_base'),
                brand: row.readNullable<String>('brand'),
                variant: row.readNullable<String>('variant'),
                supplierName: row.readNullable<String>('supplier_name'),
                unitName: row.readNullable<String>('unit_name'),
                unitFactor: row.readNullable<int>('unit_factor'),
                buyPrice: row.readNullable<int>('buy_price'),
              ),
            )
            .toList(),
      );
}
