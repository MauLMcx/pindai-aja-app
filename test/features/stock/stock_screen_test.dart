import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/features/stock/stock_screen.dart';

import 'fixtures.dart';

void main() {
  testWidgets('filter rak dan pencarian barcode menyaring daftar stok', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await seedStore(db);

    await addProduct(
      db,
      storeId: store.id,
      name: 'Whiskas Tuna',
      shelfLocation: 'Rak A-1',
      saleBarcode: '8991234567890',
    );
    await addProduct(
      db,
      storeId: store.id,
      name: 'Meo Ikan',
      shelfLocation: 'Rak B-2',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const MaterialApp(home: StockScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Whiskas Tuna'), findsOneWidget);
    expect(find.text('Meo Ikan'), findsOneWidget);

    // Filter rak: hanya barang di Rak A-1 (SPEC §6.3).
    await tester.tap(find.text('Semua rak'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rak A-1').last);
    await tester.pumpAndSettle();

    expect(find.text('Whiskas Tuna'), findsOneWidget);
    expect(find.text('Meo Ikan'), findsNothing);

    // Kembali ke semua rak, lalu cari lewat barcode.
    await tester.tap(find.text('Rak A-1'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Semua rak').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '899123');
    await tester.pumpAndSettle();

    expect(find.text('Whiskas Tuna'), findsOneWidget);
    expect(find.text('Meo Ikan'), findsNothing);
  });
}
