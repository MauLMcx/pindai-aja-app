import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/main.dart';

void main() {
  testWidgets('beranda menampilkan status offline dan ajakan impor', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kasir Petshop'), findsOneWidget);
    expect(find.text('Mode offline aktif'), findsOneWidget);
    expect(find.text('0 produk'), findsOneWidget);
    expect(find.text('Belum ada produk'), findsOneWidget);
  });

  testWidgets('produk hasil impor tampil di beranda', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);
    final now = DateTime.utc(2026, 11, 17, 10);

    await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            id: 'p1',
            storeId: store.id,
            name: 'Pakan Uji',
            baseUnit: 'gram',
            needsPriceReview: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.productUnits)
        .insert(
          ProductUnitsCompanion.insert(
            id: 'u1',
            storeId: store.id,
            productId: 'p1',
            unitName: 'dus isi 10',
            factorToBase: 30000,
            isDefaultPurchase: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await db
        .into(db.priceHistory)
        .insert(
          PriceHistoryCompanion.insert(
            id: 'ph1',
            storeId: store.id,
            productUnitId: 'u1',
            kind: PriceKind.buy,
            price: 140000,
            effectiveAt: now,
            createdAt: now,
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pakan Uji'), findsOneWidget);
    expect(find.text('Rp 140.000'), findsOneWidget);
    expect(find.text('Stok 0 gram'), findsOneWidget);
    expect(find.text('Belum ada produk'), findsNothing);
  });
}
