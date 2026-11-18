import 'package:material_ui/material_ui.dart';

/// Palet dan tema aplikasi. Satu sumber kebenaran agar semua layar konsisten.
abstract final class AppColors {
  static const Color primary = Color(0xFF0B7A63);
  static const Color primaryDeep = Color(0xFF075E4D);
  static const Color accent = Color(0xFFF2A03B);
  static const Color canvas = Color(0xFFF4F7F3);
  static const Color ink = Color(0xFF13231E);
  static const Color muted = Color(0xFF63736D);
  static const Color line = Color(0xFFE4EBE6);
  static const Color success = Color(0xFF1B9C6B);
  static const Color warning = Color(0xFFD9822B);
  static const Color danger = Color(0xFFC0392B);
}

/// Tema Material 3 dengan nuansa hijau toko yang hangat dan lembut.
abstract final class AppTheme {
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF075E4D), Color(0xFF12A184)],
  );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      surface: Colors.white,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.muted,
      error: AppColors.danger,
    );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );
    final titleStyle = text.titleLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
      color: AppColors.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.canvas,
      textTheme: text.copyWith(
        headlineSmall: text.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
        ),
        titleLarge: text.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        bodyMedium: text.bodyMedium?.copyWith(height: 1.45),
        bodySmall: text.bodySmall?.copyWith(height: 1.4),
        labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.ink,
        titleTextStyle: titleStyle,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: AppColors.muted, fontSize: 13.5),
        prefixIconColor: AppColors.muted,
        suffixIconColor: AppColors.muted,
        border: _fieldBorder(AppColors.line),
        enabledBorder: _fieldBorder(AppColors.line),
        focusedBorder: _fieldBorder(AppColors.primary, width: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDeep,
          side: const BorderSide(color: AppColors.line),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary,
        side: const BorderSide(color: AppColors.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: text.labelLarge?.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        secondaryLabelStyle: text.labelLarge?.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        showCheckmark: false,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
