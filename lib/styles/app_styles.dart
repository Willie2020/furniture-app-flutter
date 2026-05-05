import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Seed color — warm earthy brown that M3 harmonizes from
// ---------------------------------------------------------------------------
const Color _seedColor = Color(0xFFD84315); // Deep orange — warm, inviting

// ---------------------------------------------------------------------------
// AppColors — derived from M3 tonal palette for explicit use
// ---------------------------------------------------------------------------
class AppColors {
  AppColors._();

  // Core palette from seed
  static const Color primary = Color(0xFF6D4C41);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFDBC8);
  static const Color onPrimaryContainer = Color(0xFF271105);

  static const Color secondary = Color(0xFF7A573F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFDBC8);
  static const Color onSecondaryContainer = Color(0xFF2C1606);

  static const Color tertiary = Color(0xFF6C5D2E);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFF7E1A6);
  static const Color onTertiaryContainer = Color(0xFF231B00);

  // Surfaces
  static const Color background = Color(0xFFFFF8F5);
  static const Color surface = Color(0xFFFFF8F5);
  static const Color surfaceContainerLow = Color(0xFFFEF1E9);
  static const Color surfaceContainerHighest = Color(0xFFF3E5DC);

  // Semantic
  static const Color error = Color(0xFFBA1A1A);
  static const Color success = Color(0xFF2E7D32);

  // Misc
  static const Color divider = Color(0xFFD7C4B7);
  static const Color cardShadow = Color(0x1A000000);
}

// ---------------------------------------------------------------------------
// AppTheme — pure M3 via ColorScheme.fromSeed
// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    final cs = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs,

      // Let M3 drive the text theme — we only tweak what we need
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),

      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(0),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: cs.surfaceContainerHighest,
        labelStyle: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
        selectedColor: cs.primaryContainer,
        secondaryLabelStyle:
            TextStyle(color: cs.onPrimaryContainer, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AppTextStyles — convenience accessors to M3 text theme
// ---------------------------------------------------------------------------
class AppTextStyles {
  AppTextStyles._();

  static TextStyle displayLarge(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge!;
  static TextStyle headlineLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge!;
  static TextStyle headlineMedium(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium!;
  static TextStyle titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;
  static TextStyle titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;
  static TextStyle bodyLarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;
  static TextStyle bodyMedium(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
  static TextStyle labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge!;
}

// ---------------------------------------------------------------------------
// AppDecorations
// ---------------------------------------------------------------------------
class AppDecorations {
  AppDecorations._();

  static BoxDecoration cardDecoration() => BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration gradientDecoration(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [cs.primary, cs.tertiary],
      ),
    );
  }
}
