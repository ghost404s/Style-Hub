import 'package:flutter/material.dart';

/// Central design language for StyleHub.
///
/// `AppColors` exposes a runtime-switchable palette: the semantic names
/// (`ink`, `background`, `surface`, …) are getters that resolve against
/// the active brightness set via [AppColors.setBrightness], while fixed
/// accents (`accent`, `danger`, `success`, `star`) are const and stable
/// across themes.
class AppColors {
  AppColors._();

  static bool isDark = false;

  static void setBrightness(bool dark) => isDark = dark;

  // Stable accents (const, safe in const expressions).
  static const Color accent = Color(0xFF6C4CF1);
  static const Color success = Color(0xFF1F9D55);
  static const Color danger = Color(0xFFE5484D);
  static const Color star = Color(0xFFF5A623);
  static const Color gradientStart = Color(0xFF8B5CF6);
  static const Color gradientEnd = Color(0xFF6C4CF1);

  // Theme-aware surfaces & text.
  static Color get ink => isDark ? const Color(0xFFF4F2EF) : const Color(0xFF111111);
  static Color get inkSoft =>
      isDark ? const Color(0xFFD6D2CB) : const Color(0xFF2B2B2B);
  static Color get muted =>
      isDark ? const Color(0xFF9C9992) : const Color(0xFF8A8781);
  static Color get background =>
      isDark ? const Color(0xFF101012) : const Color(0xFFFAF9F6);
  static Color get surface =>
      isDark ? const Color(0xFF1B1B1E) : const Color(0xFFFFFFFF);
  static Color get surfaceAlt =>
      isDark ? const Color(0xFF232327) : const Color(0xFFF7F5F0);
  static Color get border =>
      isDark ? const Color(0xFF2C2C31) : const Color(0xFFECEAE3);
  static Color get accentLight =>
      isDark ? const Color(0xFF241B3E) : const Color(0xFFEDE9FE);
  static Color get accentVivid =>
      isDark ? const Color(0xFF8B6FFF) : const Color(0xFF6C4CF1);

  static LinearGradient accentGradient() => LinearGradient(
        colors: [
          isDark ? const Color(0xFF7C5CFF) : gradientStart,
          isDark ? const Color(0xFF5B3DD1) : gradientEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: brightness,
      primary: AppColors.accentVivid,
      secondary: AppColors.ink,
      surface: AppColors.surface,
      error: AppColors.danger,
    ).copyWith(
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      outline: AppColors.border,
      onPrimary: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      textTheme: const TextTheme().copyWith(
        displaySmall: TextStyle(
          color: AppColors.ink,
          fontSize: 34,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          height: 1.15,
        ),
        headlineSmall: TextStyle(
          color: AppColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 16,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 14,
          height: 1.4,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          side: BorderSide(color: AppColors.border),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: TextStyle(color: AppColors.muted, fontSize: 15),
        labelStyle: TextStyle(color: AppColors.muted, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.accent,
        side: BorderSide(color: AppColors.border),
        labelStyle: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? const Color(0xFFF4F2EF) : AppColors.ink,
        contentTextStyle: TextStyle(
          color: isDark ? AppColors.ink : Colors.white,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.accent
              : AppColors.border,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected) ? AppColors.accent : null,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.accent),
    );
  }
}
