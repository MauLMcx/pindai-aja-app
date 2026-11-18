import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/stock/purchase_service.dart';
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

  test('barang masuk menambah stok, HPP, riwayat harga, dan outbox', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Whiskas Tuna',
    );

    // 2 dus isi 10.000 gram, Rp 150.000 per dus.
    final result = await recordPurchase(
      db,
      storeId: store.id,
      purchasedAt: DateTime.utc(2026, 11, 10, 9),
      docNo: 'INV-001',
      lines: [
        PurchaseLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 2,
          unitCost: 150000,
        ),
      ],
      at: DateTime.utc(2026, 11, 10, 9, 1),
    );

    expect(result.total, 300000);
    expect(result.itemCount, 1);
    expect(result.warnings, isEmpty);

    expect(await db.stockBase(product.productId), 20000);
    expect(
      await movingAverageCostBase(db, product.productId),
      closeTo(15, 1e-9),
    );

    final items = await db.select(db.purchaseItems).get();
    expect(items, hasLength(1));
    expect(items.single.qtyBase, 20000);
    expect(items.single.costPerBase, closeTo(15, 1e-9));

    final price = await db.select(db.priceHistory).getSingle();
    expect(price.kind.name, 'buy');
    expect(price.price, 150000);
    expect(price.productUnitId, product.purchaseUnitId);
    expect(price.sourceRef, result.purchaseId);

    final movement = await db.select(db.stockMovements).getSingle();
    expect(movement.type.name, 'purchaseIn');
    expect(movement.qtyBaseDelta, 20000);
    expect(movement.refId, result.purchaseId);

    final outbox = await db.select(db.outbox).get();
    expect(
      outbox.map((row) => row.targetTable).toSet(),
      containsAll(<String>[
        'purchases',
        'purchase_items',
        'stock_movements',
        'price_history',
      ]),
    );
    expect(outbox.every((row) => row.syncedAt == null), isTrue);
  });

  test('harga beli berubah memunculkan peringatan selisih', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Meo Kaleng');

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

    final second = await recordPurchase(
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

    expect(second.warnings, hasLength(1));
    expect(second.warnings.single.oldPrice, 150000);
    expect(second.warnings.single.newPrice, 210000);
    expect(second.warnings.single.isIncrease, isTrue);
    expect(second.warnings.single.message, contains('naik'));

    // HPP: (10.000 × 15 + 10.000 × 21) / 20.000 = 18
    expect(
      await movingAverageCostBase(db, product.productId),
      closeTo(18, 1e-9),
    );
    expect(await db.stockBase(product.productId), 20000);
  });

  test('baris tidak valid membatalkan seluruh pembelian', () async {
    await clearOutbox(db);
    final product = await addProduct(db, storeId: store.id, name: 'Aice');

    await expectLater(
      recordPurchase(
        db,
        storeId: store.id,
        purchasedAt: DateTime.utc(2026, 11, 10, 9),
        lines: [
          PurchaseLineInput(
            productId: product.productId,
            unitId: product.purchaseUnitId,
            qty: 1,
            unitCost: 100000,
          ),
          PurchaseLineInput(
            productId: product.productId,
            unitId: product.purchaseUnitId,
            qty: 0,
            unitCost: 100000,
          ),
        ],
      ),
      throwsArgumentError,
    );

    expect(await db.select(db.purchases).get(), isEmpty);
    expect(await db.select(db.purchaseItems).get(), isEmpty);
    expect(await db.select(db.stockMovements).get(), isEmpty);
    expect(await db.select(db.outbox).get(), isEmpty);
    expect(await db.stockBase(product.productId), 0);
  });

  test('harga beli negatif ditolak', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Pasir Kucing',
    );

    await expectLater(
      recordPurchase(
        db,
        storeId: store.id,
        purchasedAt: DateTime.utc(2026, 11, 10),
        lines: [
          PurchaseLineInput(
            productId: product.productId,
            unitId: product.purchaseUnitId,
            qty: 1,
            unitCost: -1,
          ),
        ],
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.stockMovements).get(), isEmpty);
  });

  test('satuan milik produk lain ditolak', () async {
    final first = await addProduct(db, storeId: store.id, name: 'Produk A');
    final second = await addProduct(db, storeId: store.id, name: 'Produk B');

    await expectLater(
      recordPurchase(
        db,
        storeId: store.id,
        purchasedAt: DateTime.utc(2026, 11, 10),
        lines: [
          PurchaseLineInput(
            productId: first.productId,
            unitId: second.purchaseUnitId,
            qty: 1,
            unitCost: 1000,
          ),
        ],
      ),
      throwsArgumentError,
    );
  });
}
