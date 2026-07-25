import 'package:flutter/material.dart';

/// Palet warna utama Nina Chicken.
///
/// Widget tidak boleh menggunakan nilai warna hardcoded apabila warna tersebut
/// sudah tersedia pada class ini.
class AppColors {
  const AppColors._();

  // ---------------------------------------------------------------------------
  // Primary — Nina Orange
  // ---------------------------------------------------------------------------

  static const Color primary50 = Color(0xFFFFF4E8);
  static const Color primary100 = Color(0xFFFFE3C4);
  static const Color primary200 = Color(0xFFFFC98F);
  static const Color primary300 = Color(0xFFFFAA55);
  static const Color primary400 = Color(0xFFFF8D28);
  static const Color primary500 = Color(0xFFF57C00);
  static const Color primary600 = Color(0xFFD96B00);
  static const Color primary700 = Color(0xFFB65700);
  static const Color primary800 = Color(0xFF914500);
  static const Color primary900 = Color(0xFF6F3500);

  // ---------------------------------------------------------------------------
  // Secondary — Chili Red
  // ---------------------------------------------------------------------------

  static const Color secondary50 = Color(0xFFFFF0EE);
  static const Color secondary100 = Color(0xFFFFD9D4);
  static const Color secondary200 = Color(0xFFFFB4AB);
  static const Color secondary300 = Color(0xFFFA897C);
  static const Color secondary400 = Color(0xFFE85E50);
  static const Color secondary500 = Color(0xFFC83F32);
  static const Color secondary600 = Color(0xFFAB3329);
  static const Color secondary700 = Color(0xFF8C2A22);
  static const Color secondary800 = Color(0xFF6F211B);
  static const Color secondary900 = Color(0xFF521813);

  // ---------------------------------------------------------------------------
  // Tertiary — Warm Brown
  // ---------------------------------------------------------------------------

  static const Color tertiary50 = Color(0xFFF8F3EF);
  static const Color tertiary100 = Color(0xFFEDE0D6);
  static const Color tertiary200 = Color(0xFFD8C0AD);
  static const Color tertiary300 = Color(0xFFC09C7F);
  static const Color tertiary400 = Color(0xFFA87957);
  static const Color tertiary500 = Color(0xFF7D5237);
  static const Color tertiary600 = Color(0xFF68432E);
  static const Color tertiary700 = Color(0xFF533625);
  static const Color tertiary800 = Color(0xFF3F281C);
  static const Color tertiary900 = Color(0xFF2B1B13);

  // ---------------------------------------------------------------------------
  // Neutral — Cream and Charcoal
  // ---------------------------------------------------------------------------

  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFFFFDF8);
  static const Color neutral100 = Color(0xFFFFF9ED);
  static const Color neutral200 = Color(0xFFF7F0E3);
  static const Color neutral300 = Color(0xFFE9DED0);
  static const Color neutral400 = Color(0xFFCABCAF);
  static const Color neutral500 = Color(0xFF9B8B7D);
  static const Color neutral600 = Color(0xFF74665B);
  static const Color neutral700 = Color(0xFF574A40);
  static const Color neutral800 = Color(0xFF3D322A);
  static const Color neutral900 = Color(0xFF251E19);

  // ---------------------------------------------------------------------------
  // Semantic surfaces
  // ---------------------------------------------------------------------------

  static const Color background = Color(0xFFFFFBF2);
  static const Color surface = Color(0xFFFFFDF8);
  static const Color surfaceMuted = Color(0xFFF6F0E5);
  static const Color surfaceStrong = Color(0xFFECE1D2);

  // ---------------------------------------------------------------------------
  // Public storefront — warm editorial surfaces
  // ---------------------------------------------------------------------------

  static const Color publicBackground = Color(0xFFFFF8EC);
  static const Color publicSurface = Color(0xFFFFFCF6);
  static const Color publicSurfaceMuted = Color(0xFFF7EBDD);
  static const Color publicBorder = Color(0xFFE6D5C0);
  static const Color publicShadow = Color(0xFF4A2A16);

  static const Color border = Color(0xFFE2D6C7);
  static const Color borderStrong = Color(0xFFC8B9A8);

  static const Color textPrimary = Color(0xFF2C2119);
  static const Color textSecondary = Color(0xFF6E6055);
  static const Color textMuted = Color(0xFF928478);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFF8EF);

  // ---------------------------------------------------------------------------
  // Feedback
  // ---------------------------------------------------------------------------

  static const Color success = Color(0xFF2E7D32);
  static const Color successSurface = Color(0xFFEAF6EB);

  static const Color warning = Color(0xFFB26A00);
  static const Color warningSurface = Color(0xFFFFF3D9);

  static const Color error = Color(0xFFB3261E);
  static const Color errorSurface = Color(0xFFFFEDEA);

  static const Color info = Color(0xFF25689A);
  static const Color infoSurface = Color(0xFFEAF4FC);

  static const Color transparent = Colors.transparent;
}
