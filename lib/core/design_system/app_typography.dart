import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_breakpoints.dart';
import 'app_colors.dart';

/// Sistem tipografi Nina Chicken.
///
/// Heading menggunakan Plus Jakarta Sans.
/// Body dan label menggunakan Manrope.
class AppTypography {
  const AppTypography._();

  static TextTheme get textTheme {
    return TextTheme(
      displayLarge: GoogleFonts.plusJakartaSans(
        fontSize: 64,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -2,
        color: AppColors.textPrimary,
      ),
      displayMedium: GoogleFonts.plusJakartaSans(
        fontSize: 52,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
      ),
      displaySmall: GoogleFonts.plusJakartaSans(
        fontSize: 44,
        height: 1.12,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.2,
        color: AppColors.textPrimary,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        fontSize: 36,
        height: 1.18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: AppColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        fontSize: 30,
        height: 1.2,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      ),
      headlineSmall: GoogleFonts.plusJakartaSans(
        fontSize: 26,
        height: 1.24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      ),
      titleLarge: GoogleFonts.plusJakartaSans(
        fontSize: 22,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 18,
        height: 1.65,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: 13,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
      ),
    );
  }

  static TextStyle get sectionEyebrow {
    return GoogleFonts.manrope(
      fontSize: 13,
      height: 1.3,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.1,
      color: AppColors.primary600,
    );
  }

  static TextStyle get buttonLarge {
    return GoogleFonts.manrope(
      fontSize: 15,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.textOnPrimary,
    );
  }

  static TextStyle get buttonMedium {
    return GoogleFonts.manrope(
      fontSize: 14,
      height: 1.2,
      fontWeight: FontWeight.w700,
      color: AppColors.textOnPrimary,
    );
  }

  static TextStyle get caption {
    return GoogleFonts.manrope(
      fontSize: 12,
      height: 1.45,
      fontWeight: FontWeight.w500,
      color: AppColors.textMuted,
    );
  }

  static TextStyle responsiveDisplay(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < AppBreakpoints.mobile) {
      return textTheme.displaySmall!;
    }

    if (width < AppBreakpoints.tablet) {
      return textTheme.displayMedium!;
    }

    return textTheme.displayLarge!;
  }
}
