import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart' show Key;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show Material;
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/db/ledger.dart';
import 'package:petshop_pos/core/theme/app_theme.dart';
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

  Future<void> openCashier(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Kasir'));
    await tester.pumpAndSettle();
  }

  testWidgets('jual tunai: keranjang, bayar, struk, dan stok berkurang', (
    tester,
  ) async {
    await openCashier(tester);

    expect(find.text('Kasir'), findsOneWidget);
    expect(find.text('Pakan A'), findsOneWidget);

    await tester.tap(find.text('Pakan A'));
    await tester.pumpAndSettle();

    expect(find.text('Rp 10.000'), findsWidgets);
    await tester.tap(find.text('Bayar'));
    await tester.pumpAndSettle();

    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Bayar tunai'), findsOneWidget);
    await tester.tap(find.text('Bayar tunai'));
    await tester.pumpAndSettle();

    expect(find.text('Pembayaran tunai'), findsOneWidget);
    expect(find.text('Kembalian Rp 0'), findsOneWidget);
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Transaksi tersimpan'), findsOneWidget);
    expect(find.textContaining('HP'), findsOneWidget);

    final sale = (await db.select(db.sales).get()).single;
    expect(sale.receiptNo, matches(RegExp(r'^HP[0-9A-F]{6}-\d{8}-0001$')));
    expect(sale.total, 10000);
    expect(sale.paidTotal, 10000);
    expect(await db.stockBase(productA), 4);
    expect(await db.select(db.payments).get(), hasLength(1));
    expect(
      (await db.select(db.outbox).get()).where((o) => o.targetTable == 'sales'),
      hasLength(1),
    );

    await tester.tap(find.text('Transaksi baru'));
    await tester.pumpAndSettle();
    expect(find.text('Bayar'), findsNothing);
  });

  testWidgets('harga jual kosong ditanyakan lalu dipakai di keranjang', (
    tester,
  ) async {
    await (db.update(db.productUnits)
          ..where((t) => t.id.equals(unitPcsA)))
        .write(const ProductUnitsCompanion(sellPrice: Value(null)));

    await openCashier(tester);
    expect(find.text('Atur harga'), findsOneWidget);

    await tester.tap(find.text('Pakan A'));
    await tester.pumpAndSettle();

    expect(find.text('Atur harga jual'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('sell-price-input')), '12500');
    await tester.pump();
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    final unit = await (db.select(db.productUnits)
          ..where((t) => t.id.equals(unitPcsA)))
        .getSingle();
    expect(unit.sellPrice, 12500);
    expect(find.text('Rp 12.500'), findsWidgets);

    final sellPrices = await (db.select(db.priceHistory)
          ..where((t) => t.kind.equalsValue(PriceKind.sell)))
        .get();
    expect(sellPrices.single.price, 12500);
  });

  testWidgets('kartu kasir memakai warna tema gelap', (tester) async {
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: storeId,
            key: 'theme_mode',
            value: 'dark',
            updatedAt: testNow,
          ),
        );

    await openCashier(tester);

    expect(find.text('Pakan A'), findsOneWidget);
    final tile = tester.widget<Material>(
      find
          .ancestor(of: find.text('Pakan A'), matching: find.byType(Material))
          .first,
    );
    expect(tile.color, AppPalette.dark.card);
  });
}
