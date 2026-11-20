import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/features/purchasing/purchase_service.dart';
import 'package:petshop_pos/features/reports/report_service.dart';
import 'package:petshop_pos/features/returns/return_service.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;
  late PurchaseService purchases;
  late SaleService sales;
  late ReturnService returns;
  late ReportService reports;

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
    reports = ReportService(db);

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
    await db
        .into(db.expenses)
        .insert(
          ExpensesCompanion.insert(
            id: 'expense-1',
            storeId: storeId,
            category: 'listrik',
            amount: 2000,
            spentAt: testNow,
            createdAt: testNow,
            updatedAt: testNow,
          ),
        );
  });

  tearDown(() => db.close());

  Future<SalesSummary> summary() => reports.salesSummary(
    from: testNow.subtract(const Duration(days: 1)),
    to: testNow.add(const Duration(days: 1)),
  );

  test('omzet, HPP snapshot, biaya, dan laba bersih', () async {
    await sales.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 2,
          unitPrice: 10000,
        ),
      ],
      payments: const [SalePaymentInput(method: PayMethod.cash, amount: 20000)],
      soldAt: testNow,
    );

    final result = await summary();
    expect(result.omzet, 20000);
    expect(result.hpp, 12000);
    expect(result.grossProfit, 8000);
    expect(result.expenses, 2000);
    expect(result.netProfit, 6000);
    expect(result.transactionCount, 1);
    expect(result.payments.single.method, PayMethod.cash);
    expect(result.payments.single.amount, 20000);
  });

  test('retur mengurangi omzet dan HPP', () async {
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
      payments: const [SalePaymentInput(method: PayMethod.cash, amount: 20000)],
      soldAt: testNow,
    );

    await returns.returnSale(
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

    final result = await summary();
    expect(result.omzetNet, 10000);
    expect(result.hppNet, 6000);
    expect(result.grossProfit, 4000);
    expect(result.netProfit, 2000);
  });

  test('penjualan void tidak dihitung di laporan', () async {
    final sale = await sales.create(
      cashierId: staffId,
      items: const [
        SaleDraftItem(
          productId: productA,
          unitId: unitPcsA,
          qty: 1,
          unitPrice: 10000,
        ),
      ],
      payments: const [SalePaymentInput(method: PayMethod.cash, amount: 10000)],
      soldAt: testNow,
    );
    await sales.voidSale(
      saleId: sale.sale.id,
      byUserId: ownerId,
      at: testNow.add(const Duration(hours: 1)),
    );

    final result = await summary();
    expect(result.transactionCount, 0);
    expect(result.omzet, 0);
    expect(result.payments, isEmpty);
  });

  test('rentang tidak valid ditolak', () async {
    await expectLater(
      reports.salesSummary(from: testNow, to: testNow),
      throwsArgumentError,
    );
  });
}
