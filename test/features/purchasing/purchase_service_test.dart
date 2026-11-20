import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/features/purchasing/purchase_service.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late PurchaseService service;

  setUp(() async {
    db = await makeTestDb();
    service = PurchaseService(db, storeId: storeId, deviceId: deviceId);
  });

  tearDown(() => db.close());

  test('barang masuk menambah stok dan riwayat harga beli', () async {
    final result = await service.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 10,
          unitCost: 6000,
        ),
      ],
      purchasedAt: testNow,
    );

    expect(result.total, 60000);
    expect(await db.stockBase(productA), 10);
    expect(await averageCostBaseOf(db, productA), 6000);

    final prices = await db.select(db.priceHistory).get();
    expect(prices, hasLength(1));
    expect(prices.single.kind, PriceKind.buy);
    expect(prices.single.price, 6000);
  });

  test('HPP rata-rata bergerak dan peringatan harga naik', () async {
    await service.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 10,
          unitCost: 6000,
        ),
      ],
      purchasedAt: testNow,
    );

    final second = await service.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 10,
          unitCost: 8000,
        ),
      ],
      purchasedAt: testNow.add(const Duration(days: 1)),
    );

    expect(second.priceWarnings, hasLength(1));
    expect(await db.stockBase(productA), 20);
    expect(await averageCostBaseOf(db, productA), 7000);
  });

  test(
    'rata-rata bergerak memakai stok tersisa saat pembelian berikutnya',
    () async {
      await service.create(
        items: const [
          PurchaseItemInput(
            productId: productA,
            unitId: unitPcsA,
            qty: 10,
            unitCost: 6000,
          ),
        ],
        purchasedAt: testNow,
      );

      final sales = SaleService(
        db,
        storeId: storeId,
        deviceId: deviceId,
        deviceCode: deviceCode,
      );
      await sales.create(
        cashierId: staffId,
        items: const [
          SaleDraftItem(
            productId: productA,
            unitId: unitPcsA,
            qty: 5,
            unitPrice: 10000,
          ),
        ],
        payments: const [
          SalePaymentInput(method: PayMethod.cash, amount: 50000),
        ],
        soldAt: testNow.add(const Duration(hours: 1)),
      );

      await service.create(
        items: const [
          PurchaseItemInput(
            productId: productA,
            unitId: unitPcsA,
            qty: 10,
            unitCost: 9000,
          ),
        ],
        purchasedAt: testNow.add(const Duration(hours: 2)),
      );

      // (5 × 6000 + 10 × 9000) / 15 = 8000
      expect(await db.stockBase(productA), 15);
      expect(await averageCostBaseOf(db, productA), 8000);
    },
  );

  test('beli per dus dikonversi ke satuan dasar', () async {
    await service.create(
      items: const [
        PurchaseItemInput(
          productId: productA,
          unitId: unitDusA,
          qty: 1,
          unitCost: 60000,
        ),
      ],
      purchasedAt: testNow,
    );

    expect(await db.stockBase(productA), 10);
    final item = (await db.select(db.purchaseItems).get()).single;
    expect(item.qtyBase, 10);
    expect(item.costPerBase, 6000);
  });

  test('satuan milik produk lain ditolak', () async {
    await expectLater(
      service.create(
        items: const [
          PurchaseItemInput(
            productId: productA,
            unitId: unitPcsB,
            qty: 1,
            unitCost: 5000,
          ),
        ],
        purchasedAt: testNow,
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.purchases).get(), isEmpty);
  });
}
