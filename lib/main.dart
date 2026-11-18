import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: PetshopApp()));
}

class PetshopApp extends StatelessWidget {
  const PetshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir Petshop',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}
