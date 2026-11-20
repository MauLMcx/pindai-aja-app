import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/features/sales/sale_service.dart';
import 'package:petshop_pos/main.dart';

import '../../support/db_fixture.dart';

void main() {
  late AppDatabase db;

  setUp(() async {
    db = await makeTestDb();
    await addStockMovement(
      db,
      id: 'initial-a',
      storeId: storeId,
      productId: productA,
      qtyBaseDelta: 5,
      type: MovementType.initial,
      occurredAt: testNow,
      costPerBase: 6000,
      deviceId: deviceId,
    );
  });

  tearDown(() => db.close());

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('riwayat menampilkan struk dan pembatalan mengembalikan stok', (
    tester,
  ) async {
    final sale =
        await SaleService(
          db,
          storeId: storeId,
          deviceId: deviceId,
          deviceCode: deviceCode,
        ).create(
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
    expect(await db.stockBase(productA), 4);

    await pumpApp(tester);
    await tester.tap(find.byTooltip('Riwayat transaksi'));
    await tester.pumpAndSettle();

    expect(find.text('Riwayat transaksi'), findsOneWidget);
    expect(find.text(sale.sale.receiptNo), findsOneWidget);
    expect(find.text('Rp 10.000'), findsOneWidget);

    await tester.tap(find.text(sale.sale.receiptNo));
    await tester.pumpAndSettle();
    expect(find.text('Cetak ulang'), findsOneWidget);

    await tester.tap(find.text('Cetak ulang'));
    await tester.pumpAndSettle();
    expect(find.text('Cetak ulang struk'), findsOneWidget);
    expect(find.textContaining('Terima kasih'), findsWidgets);
    await tester.tap(find.text('Tutup'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Batalkan'));
    await tester.pumpAndSettle();
    expect(find.text('Batalkan transaksi?'), findsOneWidget);
    await tester.tap(find.text('Batalkan').last);
    await tester.pumpAndSettle();

    final updated = (await db.select(db.sales).get()).single;
    expect(updated.status, SaleStatus.voided);
    expect(await db.stockBase(productA), 5);
    expect(find.text('Dibatalkan'), findsOneWidget);
  });
}
