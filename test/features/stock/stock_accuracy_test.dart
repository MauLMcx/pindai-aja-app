import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/stock/opname_service.dart';
import 'package:petshop_pos/features/stock/purchase_service.dart';
import 'package:petshop_pos/features/stock/stock_math.dart';
import 'package:petshop_pos/features/stock/stock_queries.dart';

import 'fixtures.dart';

void main() {
  late AppDatabase db;
  late Store store;

  setUp(() async {
    db = AppDatabase.memory();
    store = await seedStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('stok akhir cocok dengan hitungan manual (KP Tahap 2)', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Whiskas Tuna',
    );

    await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 10, 9),
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 2,
          unitCost: 150000,
        ),
      ],
    );
    await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 11, 9),
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 1,
          unitCost: 210000,
        ),
      ],
    );
    // Penjualan 5.000 gram (Tahap 1) dan retur 1.000 gram.
    await addMovement(
      db,
      storeId: store.id,
      productId: product.productId,
      qtyBaseDelta: -5000,
      type: MovementType.saleOut,
      occurredAt: DateTime.utc(2026, 11, 12, 9),
    );
    await addMovement(
      db,
      storeId: store.id,
      productId: product.productId,
      qtyBaseDelta: 1000,
      type: MovementType.returnIn,
      occurredAt: DateTime.utc(2026, 11, 12, 10),
    );

    // Hitungan manual: 20.000 + 10.000 − 5.000 + 1.000 = 26.000.
    expect(await db.stockBase(product.productId), 26000);

    // HPP: (20.000×15 + 10.000×21) / 30.000 = 17.
    final avg = await movingAverageCostBase(db, product.productId);
    expect(avg, closeTo(17, 1e-9));
    expect(inventoryValueRupiah(26000, avg), 442000);
    expect(await totalInventoryValue(db), 442000);

    // Opname fisik 25.500 → selisih −500, nilai −8.500.
    final opnameId = await startOpname(db, storeId: store.id);
    await setOpnameCount(
      db,
      storeId: store.id,
      opnameId: opnameId,
      productId: product.productId,
      countedBase: 25500,
    );
    final finished = await finishOpname(
      db,
      storeId: store.id,
      opnameId: opnameId,
    );

    expect(finished.rows.single.diffBase, -500);
    expect(finished.rows.single.valueRupiah, -8500);
    expect(await db.stockBase(product.productId), 25500);
  });

  test('daftar perlu dibeli dikelompokkan per pemasok', () async {
    final supplierId = await addSupplier(db, store.id, 'Bintang Petshop');
    final low = await addProduct(
      db,
      storeId: store.id,
      name: 'Meo Ikan',
      minStockBase: 5000,
      supplierId: supplierId,
    );
    await addMovement(
      db,
      storeId: store.id,
      productId: low.productId,
      qtyBaseDelta: 2000,
      type: MovementType.initial,
    );

    // Stok di atas minimum → tidak masuk daftar.
    final cukup = await addProduct(
      db,
      storeId: store.id,
      name: 'Royal Canin',
      minStockBase: 1000,
      supplierId: supplierId,
    );
    await addMovement(
      db,
      storeId: store.id,
      productId: cukup.productId,
      qtyBaseDelta: 5000,
      type: MovementType.initial,
    );

    // Tanpa stok minimum → tidak pernah masuk daftar.
    final tanpaMinimum = await addProduct(db, storeId: store.id, name: 'Pasir');

    final groups = await loadLowStockGroups(db);

    expect(groups, hasLength(1));
    expect(groups.single.supplierName, 'Bintang Petshop');
    expect(groups.single.rows, hasLength(1));
    expect(groups.single.rows.single.productId, low.productId);
    expect(groups.single.rows.single.isLow, isTrue);
    expect(groups.single.rows.single.shortfallBase, 3000);
    expect(
      groups.single.rows.any((row) => row.productId == tanpaMinimum.productId),
      isFalse,
    );
  });

  test('produk tanpa pemasok masuk kelompok "Tanpa pemasok"', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Tanpa Pemasok',
      minStockBase: 10,
    );
    await addMovement(
      db,
      storeId: store.id,
      productId: product.productId,
      qtyBaseDelta: 1,
      type: MovementType.initial,
    );

    final groups = await loadLowStockGroups(db);
    expect(groups.single.supplierName, 'Tanpa pemasok');
  });

  test('pencarian stok mencocokkan nama dan barcode', () async {
    await addProduct(db, storeId: store.id, name: 'Whiskas Tuna');
    await addProduct(db, storeId: store.id, name: 'Meo Ikan');

    final byName = await loadStockRows(db, search: 'whiskas');
    expect(byName, hasLength(1));
    expect(byName.single.name, 'Whiskas Tuna');

    final none = await loadStockRows(db, search: 'tidak-ada');
    expect(none, isEmpty);
  });

  test('riwayat harga menampilkan pembelian terbaru di atas', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Meo');

    await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 10, 9),
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 1,
          unitCost: 150000,
        ),
      ],
    );
    await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 12, 9),
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 1,
          unitCost: 175000,
        ),
      ],
    );

    final history = await loadPriceHistory(db, product.productId);
    expect(history, hasLength(2));
    expect(history.first.price, 175000);
    expect(history.last.price, 150000);
    expect(history.first.unitName, 'dus');
  });
}
