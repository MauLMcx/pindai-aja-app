import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/stock/purchase_service.dart';
import 'package:petshop_pos/features/stock/return_service.dart';

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

  test(
    'retur pembelian mengurangi stok dan menulis purchase_return_out',
    () async {
      final product = await addProduct(db, storeId: store.id, name: 'Whiskas');
      final purchase = await recordPurchase(
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

      final result = await recordPurchaseReturn(
        db,
        storeId: store.id,
        purchaseId: purchase.purchaseId,
        returnedAt: DateTime.utc(2026, 11, 14, 9),
        reason: 'Kemasan rusak',
        lines: [
          ReturnLineInput(
            productId: product.productId,
            unitId: product.purchaseUnitId,
            qty: 1,
          ),
        ],
      );

      expect(result.qtyBase, 10000);
      expect(result.amount, 150000);
      expect(await db.stockBase(product.productId), 10000);

      final returns = await db.select(db.returns).getSingle();
      expect(returns.kind.name, 'purchase');
      expect(returns.purchaseId, purchase.purchaseId);
      expect(returns.refundTotal, 0);

      final returned = await db.select(db.returnItems).getSingle();
      expect(returned.qtyBase, 10000);
      expect(returned.amount, 150000);

      final movement =
          await (db.select(db.stockMovements)..where(
                (t) => t.type.equalsValue(MovementType.purchaseReturnOut),
              ))
              .getSingle();
      expect(movement.qtyBaseDelta, -10000);
      expect(movement.refId, result.returnId);
    },
  );

  test('retur pembelian melebihi sisa ditolak', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Meo');
    final purchase = await recordPurchase(
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
      ],
    );

    Future<void> retry() => recordPurchaseReturn(
      db,
      storeId: store.id,
      purchaseId: purchase.purchaseId,
      returnedAt: DateTime.utc(2026, 11, 14),
      lines: [
        ReturnLineInput(
          productId: product.productId,
          unitId: product.purchaseUnitId,
          qty: 1,
        ),
      ],
    );

    await retry();
    expect(await db.stockBase(product.productId), 0);

    await expectLater(retry(), throwsArgumentError);
    expect(await db.stockBase(product.productId), 0);
  });

  test('retur penjualan mengembalikan stok dengan HPP snapshot', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Tayo');
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

    final saleId = await addCompletedSale(
      db,
      storeId: store.id,
      receiptNo: 'INV/001',
      productId: product.productId,
      unitId: product.saleUnitId,
      qty: 2,
      qtyBase: 2000,
      lineTotal: 30000,
      costPerBase: 12,
    );
    await addMovement(
      db,
      storeId: store.id,
      productId: product.productId,
      qtyBaseDelta: -2000,
      type: MovementType.saleOut,
      occurredAt: DateTime.utc(2026, 11, 3, 9),
    );

    final result = await recordSaleReturn(
      db,
      storeId: store.id,
      saleId: saleId,
      returnedAt: DateTime.utc(2026, 11, 15, 10),
      refundMethod: PayMethod.cash,
      reason: 'Salah beli',
      lines: [
        ReturnLineInput(
          productId: product.productId,
          unitId: product.saleUnitId,
          qty: 1,
        ),
      ],
    );

    expect(result.qtyBase, 1000);
    // Refund otomatis proporsional: 30.000 × 1.000 / 2.000 = 15.000.
    expect(result.amount, 15000);
    expect(await db.stockBase(product.productId), 19000);

    final movement = await (db.select(
      db.stockMovements,
    )..where((t) => t.type.equalsValue(MovementType.returnIn))).getSingle();
    expect(movement.qtyBaseDelta, 1000);
    expect(movement.costPerBase, 12);

    final returns = await db.select(db.returns).getSingle();
    expect(returns.kind.name, 'sale');
    expect(returns.refundTotal, 15000);
    expect(returns.refundMethod?.name, 'cash');
  });

  test('retur penjualan melebihi jumlah terjual ditolak', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Aice');
    final saleId = await addCompletedSale(
      db,
      storeId: store.id,
      receiptNo: 'INV/002',
      productId: product.productId,
      unitId: product.saleUnitId,
      qty: 1,
      qtyBase: 1000,
      lineTotal: 20000,
      costPerBase: 10,
    );

    await expectLater(
      recordSaleReturn(
        db,
        storeId: store.id,
        saleId: saleId,
        returnedAt: DateTime.utc(2026, 11, 15),
        lines: [
          ReturnLineInput(
            productId: product.productId,
            unitId: product.saleUnitId,
            qty: 2,
          ),
        ],
      ),
      throwsArgumentError,
    );
    expect(await db.select(db.returns).get(), isEmpty);
  });

  test('retur dengan refund kredit mengurangi utang pelanggan', () async {
    final product = await addProduct(db, storeId: store.id, name: 'Life Cat');
    final saleId = await addCompletedSale(
      db,
      storeId: store.id,
      receiptNo: 'INV/003',
      productId: product.productId,
      unitId: product.saleUnitId,
      qty: 1,
      qtyBase: 1000,
      lineTotal: 25000,
      costPerBase: 9,
    );

    await recordSaleReturn(
      db,
      storeId: store.id,
      saleId: saleId,
      returnedAt: DateTime.utc(2026, 11, 15),
      customerId: 'pelanggan-1',
      refundMethod: PayMethod.credit,
      lines: [
        ReturnLineInput(
          productId: product.productId,
          unitId: product.saleUnitId,
          qty: 1,
        ),
      ],
    );

    final debt = await db.select(db.debtLedger).getSingle();
    expect(debt.customerId, 'pelanggan-1');
    expect(debt.delta, -25000);
    expect(debt.type.name, 'returnOffset');
  });

  test('retur tanpa struk memakai HPP rata-rata berjalan', () async {
    final product = await addProduct(
      db,
      storeId: store.id,
      name: 'Meo Tanpa Struk',
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

    final result = await recordSaleReturnWithoutInvoice(
      db,
      storeId: store.id,
      returnedAt: DateTime.utc(2026, 11, 16, 10),
      refundMethod: PayMethod.cash,
      reason: 'Tanpa struk',
      lines: [
        StandaloneReturnLineInput(
          productId: product.productId,
          unitId: product.saleUnitId,
          qty: 2,
          unitPrice: 20000,
        ),
      ],
    );

    expect(result.qtyBase, 2000);
    expect(result.amount, 40000);
    expect(await db.stockBase(product.productId), 22000);

    final returns = await db.select(db.returns).getSingle();
    expect(returns.kind.name, 'sale');
    expect(returns.saleId, isNull);
    expect(returns.refundTotal, 40000);

    final movement = await (db.select(
      db.stockMovements,
    )..where((t) => t.type.equalsValue(MovementType.returnIn))).getSingle();
    expect(movement.qtyBaseDelta, 2000);
    expect(movement.costPerBase, closeTo(15, 1e-9));
  });
}
