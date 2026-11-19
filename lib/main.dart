import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/backup/backup_service.dart';
import 'core/db/app_database.dart';
import 'core/db/database_provider.dart';
import 'core/settings/theme_mode_provider.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/app_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSupabaseIfConfigured();

  final db = AppDatabase(openAppDatabaseConnection());
  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const PetshopApp(),
    ),
  );

  unawaited(_dailyBackup(db));
}

/// Backup harian berjalan di latar belakang; kegagalan tidak mengganggu kasir.
Future<void> _dailyBackup(AppDatabase db) async {
  try {
    final path = await maybeCreateDailyBackup(db);
    if (path != null) debugPrint('Backup harian: $path');
  } catch (error) {
    debugPrint('Backup harian dilewati: $error');
  }
}

class PetshopApp extends ConsumerWidget {
  const PetshopApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider).value ?? ThemeMode.system;

    return MaterialApp(
      title: 'Kasir Petshop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      home: const AppGate(),
    );
  }
}
