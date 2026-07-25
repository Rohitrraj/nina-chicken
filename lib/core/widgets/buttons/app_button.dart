import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

/// Tombol reusable untuk frontend Kedai Ayam Nina.
///
/// Mendukung:
/// - beberapa varian visual;
/// - ukuran yang konsisten;
/// - loading state;
/// - disabled state;
/// - leading dan trailing icon;
/// - full-width atau menyesuaikan isi.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.fullWidth = false,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool fullWidth;
  final String? semanticLabel;

  bool get _isEnabled {
    return onPressed != null && !isLoading;
  }

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      button: true,
      enabled: _isEnabled,
      label: semanticLabel ?? label,
      child: _buildButton(context),
    );

    if (!fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildButton(BuildContext context) {
    final effectiveOnPressed = _isEnabled ? onPressed : null;
    final child = _ButtonContent(
      label: label,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      size: size,
      foregroundColor: _foregroundColor(context),
    );

    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return FilledButton(
          onPressed: effectiveOnPressed,
          style: _filledStyle(context),
          child: child,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: _outlinedStyle(context),
          child: child,
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: _textStyle(context),
          child: child,
        );
    }
  }

  ButtonStyle _filledStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;

    switch (variant) {
      case AppButtonVariant.secondary:
        backgroundColor = colorScheme.secondary;
        foregroundColor = colorScheme.onSecondary;

      case AppButtonVariant.danger:
        backgroundColor = colorScheme.error;
        foregroundColor = colorScheme.onError;

      case AppButtonVariant.primary:
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
    }

    return FilledButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: AppColors.neutral300,
      disabledForegroundColor: AppColors.neutral600,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
    );
  }

  ButtonStyle _outlinedStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: AppColors.neutral500,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      side: BorderSide(
        color: _isEnabled ? colorScheme.primary : AppColors.neutral400,
        width: 1.5,
      ),
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
    );
  }

  ButtonStyle _textStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: AppColors.neutral500,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
    );
  }

  Color _foregroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEnabled) {
      return AppColors.neutral600;
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.onSecondary;
      case AppButtonVariant.danger:
        return colorScheme.onError;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return colorScheme.primary;
    }
  }

  double get _height {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );

      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        );

      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
    }
  }

  TextStyle get _textStyleForSize {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonMedium;
      case AppButtonSize.medium:
      case AppButtonSize.large:
        return AppTypography.buttonLarge;
    }
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.isLoading,
    required this.size,
    required this.foregroundColor,
  });

  final String label;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final AppButtonSize size;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    final iconSize = switch (size) {
      AppButtonSize.small => 18.0,
      AppButtonSize.medium => 20.0,
      AppButtonSize.large => 22.0,
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ] else if (leadingIcon != null) ...[
          Icon(leadingIcon, size: iconSize, color: foregroundColor),
          const SizedBox(width: AppSpacing.xs),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
        if (!isLoading && trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Icon(trailingIcon, size: iconSize, color: foregroundColor),
        ],
      ],
    );
  }
}
