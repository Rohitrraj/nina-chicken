import 'package:flutter/material.dart';

import 'design_system/design_system.dart';

/// Konfigurasi tema global aplikasi Kedai Ayam Nina.
///
/// Seluruh keputusan visual dasar diambil dari design token pada folder
/// [lib/core/design_system]. Widget sebaiknya menggunakan Theme.of(context)
/// atau token terkait, bukan nilai warna dan ukuran yang ditulis berulang.
class AppTheme {
  const AppTheme._();

  // Alias sementara untuk menjaga kompatibilitas dengan source lama.
  //
  // Alias ini dapat dihapus setelah seluruh widget lama selesai dimigrasikan
  // ke AppColors pada tahap frontend cleanup.
  static const Color primaryColor = AppColors.primary500;
  static const Color secondaryColor = AppColors.secondary500;
  static const Color tertiaryColor = AppColors.tertiary500;
  static const Color neutralColor = AppColors.background;

  static const Color _darkBackground = Color(0xFF18130F);
  static const Color _darkSurface = Color(0xFF211A15);
  static const Color _darkSurfaceMuted = Color(0xFF2B221B);
  static const Color _darkBorder = Color(0xFF514237);

  /// Tema utama untuk seluruh tampilan aplikasi.
  static ThemeData lightTheme() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary500,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary900,
      secondary: AppColors.secondary500,
      onSecondary: AppColors.textOnPrimary,
      secondaryContainer: AppColors.secondary100,
      onSecondaryContainer: AppColors.secondary900,
      tertiary: AppColors.tertiary500,
      onTertiary: AppColors.textOnPrimary,
      tertiaryContainer: AppColors.tertiary100,
      onTertiaryContainer: AppColors.tertiary900,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceMuted,
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.errorSurface,
      onErrorContainer: AppColors.error,
      outline: AppColors.border,
      outlineVariant: AppColors.surfaceStrong,
      shadow: Color(0x33000000),
      scrim: Color(0x66000000),
      inverseSurface: AppColors.neutral900,
      onInverseSurface: AppColors.neutral50,
      inversePrimary: AppColors.primary300,
    );

    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      cardColor: AppColors.surface,
      dividerColor: AppColors.border,
      disabledColor: AppColors.neutral400,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,

      // -----------------------------------------------------------------------
      // App bar
      // -----------------------------------------------------------------------
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: AppColors.transparent,
        shadowColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),

      // -----------------------------------------------------------------------
      // Icon and divider
      // -----------------------------------------------------------------------
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      // -----------------------------------------------------------------------
      // Elevated button
      // -----------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.neutral300,
          disabledForegroundColor: AppColors.neutral600,
          elevation: 0,
          shadowColor: AppColors.transparent,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),

      // -----------------------------------------------------------------------
      // Filled button
      // -----------------------------------------------------------------------
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary500,
          foregroundColor: AppColors.textOnPrimary,
          disabledBackgroundColor: AppColors.neutral300,
          disabledForegroundColor: AppColors.neutral600,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonLarge,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),

      // -----------------------------------------------------------------------
      // Outlined button
      // -----------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary700,
          disabledForegroundColor: AppColors.neutral500,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonLarge.copyWith(
            color: AppColors.primary700,
          ),
          side: const BorderSide(color: AppColors.primary500, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),

      // -----------------------------------------------------------------------
      // Text button
      // -----------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary700,
          disabledForegroundColor: AppColors.neutral500,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          textStyle: AppTypography.buttonMedium.copyWith(
            color: AppColors.primary700,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),

      // -----------------------------------------------------------------------
      // Floating action button
      // -----------------------------------------------------------------------
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 2,
        focusElevation: 3,
        hoverElevation: 3,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),

      // -----------------------------------------------------------------------
      // Input
      // -----------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral0,
        isDense: false,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.primary700,
          fontWeight: FontWeight.w700,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        disabledBorder: _inputBorder(AppColors.neutral300),
        focusedBorder: _inputBorder(AppColors.primary500, width: 2),
        errorBorder: _inputBorder(AppColors.error),
        focusedErrorBorder: _inputBorder(AppColors.error, width: 2),
      ),

      // -----------------------------------------------------------------------
      // Selection controls
      // -----------------------------------------------------------------------
      checkboxTheme: CheckboxThemeData(
        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xsValue),
        ),
      ),
      radioTheme: const RadioThemeData(visualDensity: VisualDensity.compact),
      switchTheme: const SwitchThemeData(
        trackOutlineColor: WidgetStatePropertyAll(AppColors.borderStrong),
      ),

      // -----------------------------------------------------------------------
      // Feedback
      // -----------------------------------------------------------------------
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral900,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textOnDark,
        ),
        actionTextColor: AppColors.primary300,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.primary100,
        circularTrackColor: AppColors.primary100,
      ),

      // -----------------------------------------------------------------------
      // Navigation
      // -----------------------------------------------------------------------
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary100,
        labelTextStyle: WidgetStatePropertyAll(textTheme.labelMedium),
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary100,
        selectedIconTheme: const IconThemeData(color: AppColors.primary700),
        unselectedIconTheme: const IconThemeData(
          color: AppColors.textSecondary,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.primary700,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  /// Dark theme dipertahankan untuk kompatibilitas aplikasi.
  ///
  /// Fokus redesign Nina Chicken saat ini tetap pada light theme sesuai desain
  /// yang diberikan. Dark theme akan diaudit lebih lanjut pada tahap responsive
  /// dan accessibility.
  static ThemeData darkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary400,
      onPrimary: AppColors.neutral900,
      primaryContainer: AppColors.primary900,
      onPrimaryContainer: AppColors.primary100,
      secondary: AppColors.secondary400,
      onSecondary: AppColors.neutral900,
      secondaryContainer: AppColors.secondary900,
      onSecondaryContainer: AppColors.secondary100,
      tertiary: AppColors.tertiary300,
      onTertiary: AppColors.neutral900,
      tertiaryContainer: AppColors.tertiary900,
      onTertiaryContainer: AppColors.tertiary100,
      surface: _darkSurface,
      onSurface: AppColors.neutral100,
      surfaceContainerHighest: _darkSurfaceMuted,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      outline: _darkBorder,
      outlineVariant: Color(0xFF3D3129),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.neutral100,
      onInverseSurface: AppColors.neutral900,
      inversePrimary: AppColors.primary700,
    );

    final textTheme = AppTypography.textTheme.apply(
      bodyColor: AppColors.neutral200,
      displayColor: AppColors.neutral50,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _darkBackground,
      canvasColor: _darkBackground,
      cardColor: _darkSurface,
      dividerColor: _darkBorder,
      textTheme: textTheme,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: AppColors.neutral50,
        surfaceTintColor: AppColors.transparent,
        shadowColor: AppColors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.neutral50,
        ),
        iconTheme: const IconThemeData(color: AppColors.neutral50),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary400,
          foregroundColor: AppColors.neutral900,
          elevation: 0,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonLarge.copyWith(
            color: AppColors.neutral900,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary300,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          side: const BorderSide(color: AppColors.primary400, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceMuted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
        labelStyle: textTheme.bodyMedium?.copyWith(color: AppColors.neutral300),
        prefixIconColor: AppColors.neutral300,
        suffixIconColor: AppColors.neutral300,
        border: _inputBorder(_darkBorder),
        enabledBorder: _inputBorder(_darkBorder),
        disabledBorder: _inputBorder(AppColors.neutral700),
        focusedBorder: _inputBorder(AppColors.primary400, width: 2),
        errorBorder: _inputBorder(colorScheme.error),
        focusedErrorBorder: _inputBorder(colorScheme.error, width: 2),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary400,
        foregroundColor: AppColors.neutral900,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.neutral100,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.neutral900,
        ),
        actionTextColor: AppColors.primary700,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary400,
        linearTrackColor: _darkSurfaceMuted,
        circularTrackColor: _darkSurfaceMuted,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: AppRadius.sm,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
