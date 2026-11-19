import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:petshop_pos/core/auth/session_provider.dart';
import 'package:petshop_pos/core/db/app_database.dart';
import 'package:petshop_pos/core/db/database_provider.dart';
import 'package:petshop_pos/core/store/local_store.dart';
import 'package:petshop_pos/core/theme/app_theme.dart';
import 'package:petshop_pos/features/home/home_screen.dart';
import 'package:petshop_pos/features/settings/settings_screen.dart';

void main() {
  testWidgets('pemilik melihat tombol impor', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);

    await tester.pumpWidget(
      _wrap(db, store.id, UserRole.owner, const HomeScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Impor produk'), findsOneWidget);
    expect(find.byTooltip('Pengaturan'), findsOneWidget);
  });

  testWidgets('pemilik melihat bagian backup di pengaturan', (tester) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);

    await tester.pumpWidget(
      _wrap(db, store.id, UserRole.owner, const SettingsScreen()),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Buat file backup'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Buat file backup'), findsOneWidget);
    expect(find.text('Pulihkan'), findsOneWidget);
  });

  testWidgets('kasir tidak melihat tombol impor tetapi tetap bisa pengaturan', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);

    await tester.pumpWidget(
      _wrap(db, store.id, UserRole.staff, const HomeScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Impor produk'), findsNothing);
    expect(find.byTooltip('Pengaturan'), findsOneWidget);
  });

  testWidgets('kasir tidak melihat bagian backup di pengaturan', (
    tester,
  ) async {
    final db = AppDatabase.memory();
    addTearDown(db.close);
    final store = await ensureLocalStore(db);

    await tester.pumpWidget(
      _wrap(db, store.id, UserRole.staff, const SettingsScreen()),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Sinkron'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Sinkron'), findsOneWidget);
    expect(find.text('Buat file backup'), findsNothing);
    expect(find.text('Backup'), findsNothing);
  });
}

Widget _wrap(AppDatabase db, String storeId, UserRole role, Widget home) {
  return ProviderScope(
    overrides: [
      appDatabaseProvider.overrideWithValue(db),
      sessionProvider.overrideWith(
        () => _FixedSession(_session(storeId, role)),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: home,
    ),
  );
}

AppSession _session(String storeId, UserRole role) {
  return AppSession(
    status: SessionStatus.signedIn,
    role: role,
    storeId: storeId,
    storeName: 'Toko Utama',
    displayName: role == UserRole.owner ? 'Pemilik' : 'Kasir',
    email: 'uji@toko.id',
    deviceId: 'perangkat-uji',
  );
}

class _FixedSession extends SessionController {
  _FixedSession(this.session);

  final AppSession session;

  @override
  Future<AppSession> build() async => session;
}
