import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/products/product_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late ProductService service;

  setUp(() async {
    db = await makeTestDb();
    service = ProductService(db, storeId: storeId, deviceId: deviceId);
    await (db.update(db.products)..where((t) => t.id.equals(productA))).write(
      const ProductsCompanion(needsPriceReview: Value(true)),
    );
  });

  tearDown(() => db.close());

  test(
    'harga jual tersimpan, tercatat di riwayat, dan menambah outbox',
    () async {
      await service.setSellPrice(
        productId: productA,
        unitId: unitPcsA,
        price: 12000,
        at: testNow,
      );

      final unit = await (db.select(
        db.productUnits,
      )..where((t) => t.id.equals(unitPcsA))).getSingle();
      expect(unit.sellPrice, 12000);

      final prices = await (db.select(
        db.priceHistory,
      )..where((t) => t.kind.equalsValue(PriceKind.sell))).get();
      expect(prices, hasLength(1));
      expect(prices.single.price, 12000);
      expect(prices.single.productUnitId, unitPcsA);

      final product = await (db.select(
        db.products,
      )..where((t) => t.id.equals(productA))).getSingle();
      expect(product.needsPriceReview, isFalse);

      final tables = (await db.select(db.outbox).get())
          .map((row) => '${row.targetTable}:${row.op}')
          .toSet();
      expect(tables, contains('product_units:update'));
      expect(tables, contains('price_history:insert'));
      expect(tables, contains('products:update'));
    },
  );

  test('harga negatif dan satuan produk lain ditolak', () async {
    await expectLater(
      service.setSellPrice(productId: productA, unitId: unitPcsA, price: -1),
      throwsArgumentError,
    );
    await expectLater(
      service.setSellPrice(productId: productA, unitId: unitPcsB, price: 1000),
      throwsArgumentError,
    );

    final unit = await (db.select(
      db.productUnits,
    )..where((t) => t.id.equals(unitPcsA))).getSingle();
    expect(unit.sellPrice, 10000);
  });
}
