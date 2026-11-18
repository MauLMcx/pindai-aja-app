import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

/// Warna dasar aplikasi. Dipakai untuk menyusun [AppPalette] terang & gelap.
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

/// Warna semantik yang dibutuhkan layar. Satu set untuk terang, satu untuk gelap.
///
/// Layar sebaiknya memakai `AppPalette.of(context)` dan bukan warna tetap,
/// supaya otomatis ikut saat pengguna mengganti tema.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.canvas,
    required this.card,
    required this.line,
    required this.muted,
    required this.ink,
    required this.primary,
    required this.onPrimary,
    required this.primaryDeep,
    required this.success,
    required this.warning,
    required this.danger,
    required this.infoBackground,
    required this.fieldFill,
    required this.heroGradient,
  });

  final Color canvas;
  final Color card;
  final Color line;
  final Color muted;
  final Color ink;
  final Color primary;
  final Color onPrimary;
  final Color primaryDeep;
  final Color success;
  final Color warning;
  final Color danger;
  final Color infoBackground;
  final Color fieldFill;
  final LinearGradient heroGradient;

  static const AppPalette light = AppPalette(
    canvas: AppColors.canvas,
    card: Colors.white,
    line: AppColors.line,
    muted: AppColors.muted,
    ink: AppColors.ink,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryDeep: AppColors.primaryDeep,
    success: AppColors.success,
    warning: AppColors.warning,
    danger: AppColors.danger,
    infoBackground: Color(0xFFFFF7EA),
    fieldFill: Colors.white,
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF075E4D), Color(0xFF12A184)],
    ),
  );

  static const AppPalette dark = AppPalette(
    canvas: Color(0xFF0D1512),
    card: Color(0xFF16211C),
    line: Color(0xFF2A3A33),
    muted: Color(0xFF93A79E),
    ink: Color(0xFFE8F1EC),
    primary: Color(0xFF4FD1AE),
    onPrimary: Color(0xFF063A2F),
    primaryDeep: Color(0xFF8BE8CF),
    success: Color(0xFF3DD68C),
    warning: Color(0xFFF2B05E),
    danger: Color(0xFFFF8A80),
    infoBackground: Color(0xFF2B2418),
    fieldFill: Color(0xFF16211C),
    heroGradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF064236), Color(0xFF0B7C68)],
    ),
  );

  static AppPalette of(BuildContext context) {
    return Theme.of(context).extension<AppPalette>() ?? light;
  }

  @override
  AppPalette copyWith({
    Color? canvas,
    Color? card,
    Color? line,
    Color? muted,
    Color? ink,
    Color? primary,
    Color? onPrimary,
    Color? primaryDeep,
    Color? success,
    Color? warning,
    Color? danger,
    Color? infoBackground,
    Color? fieldFill,
    LinearGradient? heroGradient,
  }) {
    return AppPalette(
      canvas: canvas ?? this.canvas,
      card: card ?? this.card,
      line: line ?? this.line,
      muted: muted ?? this.muted,
      ink: ink ?? this.ink,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryDeep: primaryDeep ?? this.primaryDeep,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      danger: danger ?? this.danger,
      infoBackground: infoBackground ?? this.infoBackground,
      fieldFill: fieldFill ?? this.fieldFill,
      heroGradient: heroGradient ?? this.heroGradient,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      card: Color.lerp(card, other.card, t)!,
      line: Color.lerp(line, other.line, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryDeep: Color.lerp(primaryDeep, other.primaryDeep, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      infoBackground: Color.lerp(infoBackground, other.infoBackground, t)!,
      fieldFill: Color.lerp(fieldFill, other.fieldFill, t)!,
      heroGradient: LinearGradient.lerp(heroGradient, other.heroGradient, t)!,
    );
  }
}

/// Tema Material 3: terang dan gelap, dengan komponen yang seragam.
abstract final class AppTheme {
  static ThemeData get light => _build(AppPalette.light, Brightness.light);

  static ThemeData get dark => _build(AppPalette.dark, Brightness.dark);

  static ThemeData _build(AppPalette palette, Brightness brightness) {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: palette.primary,
          onPrimary: palette.onPrimary,
          secondary: palette.warning,
          surface: palette.card,
          onSurface: palette.ink,
          onSurfaceVariant: palette.muted,
          error: palette.danger,
          outlineVariant: palette.line,
        );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    final text = base.textTheme.apply(
      bodyColor: palette.ink,
      displayColor: palette.ink,
    );
    final titleStyle = text.titleLarge?.copyWith(
      fontSize: 18,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
      color: palette.ink,
    );

    return base.copyWith(
      scaffoldBackgroundColor: palette.canvas,
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
        backgroundColor: palette.canvas,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        foregroundColor: palette.ink,
        titleTextStyle: titleStyle,
        systemOverlayStyle:
            (brightness == Brightness.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark)
                .copyWith(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: palette.canvas,
                  systemNavigationBarIconBrightness:
                      brightness == Brightness.dark
                      ? Brightness.light
                      : Brightness.dark,
                ),
      ),
      cardTheme: CardThemeData(
        color: palette.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: palette.line),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.fieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: palette.muted, fontSize: 13.5),
        prefixIconColor: palette.muted,
        suffixIconColor: palette.muted,
        border: _fieldBorder(palette.line),
        enabledBorder: _fieldBorder(palette.line),
        focusedBorder: _fieldBorder(palette.primary, width: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primaryDeep,
          side: BorderSide(color: palette.line),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: palette.card,
        selectedColor: palette.primary,
        side: BorderSide(color: palette.line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: text.labelLarge?.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
          color: palette.ink,
        ),
        secondaryLabelStyle: text.labelLarge?.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: palette.onPrimary,
        ),
        showCheckmark: false,
      ),
      dividerTheme: DividerThemeData(
        color: palette.line,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFF243630)
            : AppColors.ink,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      extensions: [palette],
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
