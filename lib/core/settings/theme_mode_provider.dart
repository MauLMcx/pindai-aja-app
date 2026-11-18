import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../db/app_database.dart';
import '../db/database_provider.dart';
import '../store/local_store.dart';

/// Kunci penyimpanan pilihan tema di tabel `app_settings`.
const String themeModeSettingKey = 'theme_mode';

/// Pilihan tema aplikasi: ikut sistem, terang, atau gelap.
///
/// Nilai disimpan di SQLite lokal, jadi tetap sama setelah aplikasi ditutup.
class ThemeModeController extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    final db = ref.watch(appDatabaseProvider);
    final store = await ensureLocalStore(db);
    final row =
        await (db.select(db.appSettings)..where(
              (t) =>
                  t.storeId.equals(store.id) &
                  t.key.equals(themeModeSettingKey),
            ))
            .getSingleOrNull();
    return _decode(row?.value);
  }

  Future<void> select(ThemeMode mode) async {
    state = AsyncData(mode);
    final db = ref.read(appDatabaseProvider);
    final store = await ensureLocalStore(db);
    await db
        .into(db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(
            storeId: store.id,
            key: themeModeSettingKey,
            value: _encode(mode),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
  }
}

final themeModeProvider = AsyncNotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

ThemeMode _decode(String? value) {
  return switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

String _encode(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
