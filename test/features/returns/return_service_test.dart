import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/features/purchasing/purchase_service.dart';
import 'package:petshop_pos/features/returns/return_service.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late PurchaseService purchases;
  late SaleService sales;
  late ReturnService returns;

  setUp(() async {
    db = await makeTestDb();
    purchases = PurchaseService(db, storeId: storeId, deviceId: deviceId);
    sales = SaleService(
      db,
      storeId: storeId,
      deviceId: deviceId,
      deviceCode: deviceCode,
    );
    returns = ReturnService(db, storeId: storeId, deviceId: deviceId);

    await purchases.create(
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
  });

  tearDown(() => db.close());

  test('retur penjualan mengembalikan stok dengan HPP asal', () async {
    final sale = await sales.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 2,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 20000),
      ],
      soldAt: testNow,
    );
    expect(await db.stockBase(productA), 8);

    final result = await returns.returnSale(
      saleId: sale.sale.id,
      items: const [
        ReturnItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          amount: 10000,
        ),
      ],
      refundMethod: PayMethod.cash,
      returnedAt: testNow.add(const Duration(hours: 1)),
    );

    expect(result.refundTotal, 10000);
    expect(result.stockDeltaBase, 1);
    expect(await db.stockBase(productA), 9);
    expect(result.row.kind, ReturnKind.sale);

    final item = (await db.select(db.returnItems).get()).single;
    expect(item.costPerBase, 6000);

    final movement = await (db.select(db.stockMovements)
          ..where((t) => t.type.equalsValue(MovementType.returnIn)))
        .getSingle();
    expect(movement.qtyBaseDelta, 1);
  });

  test('refund kredit mengurangi utang pelanggan', () async {
    final sale = await sales.create(
      cashierId: staffId,
      customerId: customerId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 2,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 5000),
      ],
      soldAt: testNow,
    );
    expect(await debtBalanceOf(db, customerId), 15000);

    await returns.returnSale(
      saleId: sale.sale.id,
      customerId: customerId,
      items: const [
        ReturnItemInput(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          amount: 10000,
        ),
      ],
      refundMethod: PayMethod.credit,
      returnedAt: testNow.add(const Duration(hours: 1)),
    );

    expect(await debtBalanceOf(db, customerId), 5000);
  });

  test('retur pembelian mengurangi stok', () async {
    final purchase = await purchases.create(
      items: const [
        PurchaseItemInput(
          productId: productB,
          unitId: unitPcsB,
          qty: 5,
          unitCost: 5000,
        ),
      ],
      purchasedAt: testNow,
    );
    expect(await db.stockBase(productB), 5);

    final result = await returns.returnPurchase(
      purchaseId: purchase.purchase.id,
      items: const [
        ReturnItemInput(
          productId: productB,
          unitId: unitPcsB,
          qty: 2,
          amount: 10000,
        ),
      ],
      returnedAt: testNow.add(const Duration(hours: 1)),
    );

    expect(result.stockDeltaBase, -2);
    expect(await db.stockBase(productB), 3);
    expect(result.row.kind, ReturnKind.purchase);

    final movement = await (db.select(db.stockMovements)
          ..where(
            (t) => t.type.equalsValue(MovementType.purchaseReturnOut),
          ))
        .getSingle();
    expect(movement.qtyBaseDelta, -2);
  });
}
