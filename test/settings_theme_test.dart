import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/settings/theme_mode_provider.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/main.dart';

void main() {
  testWidgets('pengaturan menyimpan pilihan tema gelap', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.system,
    );

    await tester.tap(find.byTooltip('Pengaturan'));
    await tester.pumpAndSettle();

    expect(find.text('Pengaturan'), findsOneWidget);
    expect(find.text('Ikuti sistem'), findsOneWidget);
    expect(find.text('Terang'), findsOneWidget);
    expect(find.text('Gelap'), findsOneWidget);

    await tester.tap(find.text('Gelap'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
    expect(
      Theme.of(tester.element(find.text('Pengaturan'))).brightness,
      Brightness.dark,
    );

    final store = await ensureLocalStore(db);
    final rows = await (db.select(
      db.appSettings,
    )..where((t) => t.storeId.equals(store.id))).get();
    final saved = rows.singleWhere((row) => row.key == themeModeSettingKey);
    expect(saved.value, 'dark');
  });

  testWidgets('pilihan tema tetap dipakai setelah aplikasi dibuka ulang', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);
    await db
        .into(db.appSettings)
        .insert(
          AppSettingsCompanion.insert(
            storeId: store.id,
            key: themeModeSettingKey,
            value: 'light',
            updatedAt: DateTime.utc(2026, 11, 18),
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: const PetshopApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
    expect(
      Theme.of(tester.element(find.text('Kasir Petshop'))).brightness,
      Brightness.light,
    );
  });
}
