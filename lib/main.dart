import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/settings/theme_mode_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: PetshopApp()));
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
      home: const HomeScreen(),
    );
  }
}
