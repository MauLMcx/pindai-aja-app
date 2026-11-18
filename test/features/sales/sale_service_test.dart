import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late SaleService service;

  setUp(() async {
    db = await makeTestDb();
    service = SaleService(
      db,
      storeId: storeId,
      deviceId: deviceId,
      deviceCode: deviceCode,
    );
  });

  tearDown(() => db.close());

  test('penjualan tunai: stok, pembayaran, dan outbox satu transaksi', () async {
    final result = await service.create(
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

    expect(result.sale.total, 20000);
    expect(result.sale.paidTotal, 20000);
    expect(result.changeAmount, 0);
    expect(result.debtAmount, 0);
    expect(result.sale.receiptNo, 'T1-20261118-0001');
    expect(await db.stockBase(productA), -2);

    final outbox = await db.select(db.outbox).get();
    expect(outbox.where((o) => o.targetTable == 'sales'), hasLength(1));
    expect(outbox.where((o) => o.targetTable == 'sale_items'), hasLength(1));
    expect(outbox.where((o) => o.targetTable == 'payments'), hasLength(1));
    expect(outbox.where((o) => o.targetTable == 'stock_movements'), hasLength(1));
  });

  test('nomor struk naik per transaksi di hari yang sama', () async {
    await _sale(service);
    final second = await _sale(service);

    expect(second.sale.receiptNo, 'T1-20261118-0002');
  });

  test('diskon baris dan transaksi dihitung sebagai nominal', () async {
    final result = await service.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 2,
          unitPrice: 10000,
          discount: 1000,
        ),
      ],
      discountTotal: 500,
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 10000),
        SalePaymentInput(method: PayMethod.qris, amount: 8500),
      ],
      soldAt: testNow,
    );

    expect(result.sale.subtotal, 19000);
    expect(result.sale.discountTotal, 500);
    expect(result.sale.total, 18500);
    expect(result.sale.paidTotal, 18500);
    expect(result.changeAmount, 0);
  });

  test('penjualan kredit menambah utang pelanggan', () async {
    final result = await service.create(
      cashierId: staffId,
      customerId: customerId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          unitPrice: 20000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 5000),
      ],
      soldAt: testNow,
    );

    expect(result.debtAmount, 15000);
    expect(await debtBalanceOf(db, customerId), 15000);
  });

  test('kredit tanpa pelanggan ditolak dan tidak menyisakan data', () async {
    await expectLater(
      service.create(
        cashierId: staffId,
        items: const [
          SaleDraftItem(
            productId: productA,
            unitId: unitPcsA,
            qty: 1,
            unitPrice: 20000,
          ),
        ],
        payments: const [
          SalePaymentInput(method: PayMethod.cash, amount: 5000),
        ],
        soldAt: testNow,
      ),
      throwsStateError,
    );

    expect(await db.select(db.sales).get(), isEmpty);
    expect(await db.stockBase(productA), 0);
  });

  test('kelebihan bayar tunai menjadi kembalian', () async {
    final result = await service.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          unitPrice: 20000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 25000),
      ],
      soldAt: testNow,
    );

    expect(result.changeAmount, 5000);
    expect(result.sale.changeAmount, 5000);
  });

  test('transaksi ditahan tidak mengubah stok dan tidak mencatat bayar', () async {
    final result = await service.create(
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
      status: SaleStatus.hold,
    );

    expect(result.sale.status, SaleStatus.hold);
    expect(await db.stockBase(productA), 0);
    expect(await db.select(db.payments).get(), isEmpty);
  });

  test('satuan dus memakai faktor ke satuan dasar', () async {
    final result = await service.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitDusA,
          qty: 1,
          unitPrice: 95000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 95000),
      ],
      soldAt: testNow,
    );

    expect(result.sale.total, 95000);
    expect(await db.stockBase(productA), -10);
    final item = (await db.select(db.saleItems).get()).single;
    expect(item.qty, 1);
    expect(item.qtyBase, 10);
  });

  test('void oleh pemilik mengembalikan stok dan membalik utang', () async {
    final result = await service.create(
      cashierId: staffId,
      customerId: customerId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 3,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 10000),
      ],
      soldAt: testNow,
    );
    expect(await db.stockBase(productA), -3);
    expect(await debtBalanceOf(db, customerId), 20000);

    await service.voidSale(
      saleId: result.sale.id,
      byUserId: ownerId,
      at: testNow.add(const Duration(hours: 1)),
    );

    expect(await db.stockBase(productA), 0);
    expect(await debtBalanceOf(db, customerId), 0);
    final sale = (await db.select(db.sales).get()).single;
    expect(sale.status, SaleStatus.voided);
  });

  test('void oleh staf ditolak', () async {
    final result = await service.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          unitPrice: 10000,
        ),
      ],
      payments: const [
        SalePaymentInput(method: PayMethod.cash, amount: 10000),
      ],
      soldAt: testNow,
    );

    await expectLater(
      service.voidSale(saleId: result.sale.id, byUserId: staffId),
      throwsStateError,
    );
    expect(await db.stockBase(productA), -1);
  });
}

Future<SaleResult> _sale(SaleService service) {
  return service.create(
    cashierId: staffId,
    items: const [
      SaleDraftItem(
        productId: productA,
        unitId: unitPcsA,
        qty: 1,
        unitPrice: 10000,
      ),
    ],
    payments: const [
      SalePaymentInput(method: PayMethod.cash, amount: 10000),
    ],
    soldAt: testNow,
  );
}
