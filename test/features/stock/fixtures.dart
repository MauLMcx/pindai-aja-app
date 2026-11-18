import 'package:drift/drift.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/ids.dart';
import 'package:petshop_pos/core/store/local_store.dart';

/// Data uji: satu produk dengan satuan jual dan satuan beli.
class ProductFixture {
  const ProductFixture({
    required this.productId,
    required this.saleUnitId,
    required this.purchaseUnitId,
  });

  final String productId;
  final String saleUnitId;
  final String purchaseUnitId;
}

Future<Store> seedStore(AppDatabase db) => ensureLocalStore(db);

/// Menghapus outbox bawaan (baris toko) agar tes fokus pada tulisan fitur.
Future<void> clearOutbox(AppDatabase db) => db.delete(db.outbox).go();

Future<String> addSupplier(AppDatabase db, String storeId, String name) async {
  final id = newId();
  final now = DateTime.utc(2026, 11, 1);
  await db
      .into(db.suppliers)
      .insert(
        SuppliersCompanion.insert(
          id: id,
          storeId: storeId,
          name: name,
          createdAt: now,
          updatedAt: now,
        ),
      );
  return id;
}

/// Membuat produk + dua satuan: `pcs` (jual) dan `dus` (beli).
Future<ProductFixture> addProduct(
  AppDatabase db, {
  required String storeId,
  required String name,
  String baseUnit = 'gram',
  int minStockBase = 0,
  String? supplierId,
  int saleFactor = 1000,
  int purchaseFactor = 10000,
  int? sellPrice = 20000,
  String? shelfLocation,
}) async {
  final now = DateTime.utc(2026, 11, 1);
  final productId = newId();
  await db
      .into(db.products)
      .insert(
        ProductsCompanion.insert(
          id: productId,
          storeId: storeId,
          name: name,
          baseUnit: baseUnit,
          minStockBase: Value(minStockBase),
          mainSupplierId: Value(supplierId),
          shelfLocation: Value(shelfLocation),
          createdAt: now,
          updatedAt: now,
        ),
      );

  final saleUnitId = newId();
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: saleUnitId,
          storeId: storeId,
          productId: productId,
          unitName: 'pcs',
          factorToBase: saleFactor,
          sellPrice: Value(sellPrice),
          isDefaultSale: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

  final purchaseUnitId = newId();
  await db
      .into(db.productUnits)
      .insert(
        ProductUnitsCompanion.insert(
          id: purchaseUnitId,
          storeId: storeId,
          productId: productId,
          unitName: 'dus',
          factorToBase: purchaseFactor,
          isDefaultPurchase: const Value(true),
          createdAt: now,
          updatedAt: now,
        ),
      );

  return ProductFixture(
    productId: productId,
    saleUnitId: saleUnitId,
    purchaseUnitId: purchaseUnitId,
  );
}

/// Menulis mutasi stok langsung. Dipakai untuk meniru penjualan Tahap 1.
Future<void> addMovement(
  AppDatabase db, {
  required String storeId,
  required String productId,
  required int qtyBaseDelta,
  required MovementType type,
  DateTime? occurredAt,
  double? costPerBase,
}) async {
  final id = newId();
  await db
      .into(db.stockMovements)
      .insert(
        StockMovementsCompanion.insert(
          id: id,
          storeId: storeId,
          productId: productId,
          qtyBaseDelta: qtyBaseDelta,
          type: type,
          costPerBase: Value(costPerBase),
          occurredAt: occurredAt ?? DateTime.utc(2026, 11, 2),
        ),
      );
}

/// Menulis dokumen penjualan minimal, agar retur penjualan bisa diuji.
Future<String> addCompletedSale(
  AppDatabase db, {
  required String storeId,
  required String receiptNo,
  required String productId,
  required String unitId,
  required int qty,
  required int qtyBase,
  required int lineTotal,
  double? costPerBase,
  DateTime? soldAt,
}) async {
  final now = soldAt ?? DateTime.utc(2026, 11, 3, 9);
  final saleId = newId();
  await db
      .into(db.sales)
      .insert(
        SalesCompanion.insert(
          id: saleId,
          storeId: storeId,
          receiptNo: receiptNo,
          cashierId: 'kasir-uji',
          soldAt: now,
          subtotal: lineTotal,
          total: lineTotal,
          paidTotal: lineTotal,
          createdAt: now,
          updatedAt: now,
        ),
      );
  await db
      .into(db.saleItems)
      .insert(
        SaleItemsCompanion.insert(
          id: newId(),
          storeId: storeId,
          saleId: saleId,
          productId: productId,
          unitId: unitId,
          qty: qty,
          qtyBase: qtyBase,
          unitPrice: lineTotal ~/ qty,
          lineTotal: lineTotal,
          costPerBase: Value(costPerBase),
          createdAt: now,
          updatedAt: now,
        ),
      );
  return saleId;
}
