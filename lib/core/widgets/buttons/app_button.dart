import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

/// Tombol reusable Kedai Ayam Nina.
///
/// [premium] bersifat opt-in agar perubahan visual storefront publik
/// tidak mengubah halaman admin secara tidak sengaja.
class AppButton extends StatefulWidget {
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
    this.premium = false,
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

  /// Mengaktifkan gradient halus, radius refined,
  /// shadow lembut, dan hover lift untuk storefront publik.
  final bool premium;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;

  bool get _isEnabled {
    return widget.onPressed != null && !widget.isLoading;
  }

  bool get _supportsLift {
    return widget.premium && widget.variant != AppButtonVariant.text;
  }

  bool get _isLifted {
    return _supportsLift && _isEnabled && _hovered;
  }

  @override
  Widget build(BuildContext context) {
    final button = Semantics(
      button: true,
      enabled: _isEnabled,
      label: widget.semanticLabel ?? widget.label,
      child: MouseRegion(
        cursor: _isEnabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) {
          if (_supportsLift && _isEnabled && !_hovered) {
            setState(() {
              _hovered = true;
            });
          }
        },
        onExit: (_) {
          if (_hovered) {
            setState(() {
              _hovered = false;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 190),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _isLifted ? -2 : 0, 0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: _buttonRadius,
            boxShadow: _premiumShadows,
          ),
          child: _buildButton(context),
        ),
      ),
    );

    if (!widget.fullWidth) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }

  Widget _buildButton(BuildContext context) {
    final effectiveOnPressed = _isEnabled ? widget.onPressed : null;

    final child = _ButtonContent(
      label: widget.label,
      leadingIcon: widget.leadingIcon,
      trailingIcon: widget.trailingIcon,
      isLoading: widget.isLoading,
      size: widget.size,
      foregroundColor: _foregroundColor(context),
    );

    switch (widget.variant) {
      case AppButtonVariant.primary:
        if (widget.premium) {
          return _buildPremiumPrimary(context, effectiveOnPressed, child);
        }

        return FilledButton(
          onPressed: effectiveOnPressed,
          style: _filledStyle(context),
          child: child,
        );

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
          style: _textButtonStyle(context),
          child: child,
        );
    }
  }

  Widget _buildPremiumPrimary(
    BuildContext context,
    VoidCallback? effectiveOnPressed,
    Widget child,
  ) {
    final decoration = BoxDecoration(
      color: _isEnabled ? null : AppColors.neutral300,
      gradient: _isEnabled
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary500,
                AppColors.primary600,
                AppColors.primary700,
              ],
              stops: [0, 0.56, 1],
            )
          : null,
      borderRadius: _buttonRadius,
      border: Border.all(
        color: _isEnabled
            ? AppColors.primary400.withValues(alpha: 0.50)
            : AppColors.neutral400,
        width: 1,
      ),
    );

    return DecoratedBox(
      decoration: decoration,
      child: FilledButton(
        onPressed: effectiveOnPressed,
        style: _filledStyle(context),
        child: child,
      ),
    );
  }

  ButtonStyle _filledStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color foregroundColor;

    switch (widget.variant) {
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

    final usesPremiumGradient =
        widget.premium && widget.variant == AppButtonVariant.primary;

    return FilledButton.styleFrom(
      backgroundColor: usesPremiumGradient
          ? Colors.transparent
          : backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: usesPremiumGradient
          ? Colors.transparent
          : AppColors.neutral300,
      disabledForegroundColor: AppColors.neutral600,
      shadowColor: Colors.transparent,
      elevation: 0,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
      overlayColor: usesPremiumGradient
          ? Colors.white.withValues(alpha: 0.11)
          : null,
      animationDuration: const Duration(milliseconds: 190),
    );
  }

  ButtonStyle _outlinedStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return OutlinedButton.styleFrom(
      foregroundColor: widget.premium
          ? AppColors.primary700
          : colorScheme.primary,
      backgroundColor: widget.premium
          ? AppColors.publicSurface.withValues(alpha: 0.76)
          : Colors.transparent,
      disabledForegroundColor: AppColors.neutral500,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      side: BorderSide(
        color: _isEnabled
            ? colorScheme.primary.withValues(alpha: widget.premium ? 0.68 : 1)
            : AppColors.neutral400,
        width: widget.premium ? 1 : 1.5,
      ),
      shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
      overlayColor: widget.premium
          ? AppColors.primary100.withValues(alpha: 0.72)
          : null,
      animationDuration: const Duration(milliseconds: 190),
    );
  }

  ButtonStyle _textButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.styleFrom(
      foregroundColor: colorScheme.primary,
      disabledForegroundColor: AppColors.neutral500,
      minimumSize: Size(0, _height),
      padding: _padding,
      textStyle: _textStyleForSize,
      shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
      overlayColor: widget.premium
          ? AppColors.primary100.withValues(alpha: 0.55)
          : null,
      animationDuration: const Duration(milliseconds: 190),
    );
  }

  Color _foregroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (!_isEnabled) {
      return AppColors.neutral600;
    }

    switch (widget.variant) {
      case AppButtonVariant.primary:
        return colorScheme.onPrimary;
      case AppButtonVariant.secondary:
        return colorScheme.onSecondary;
      case AppButtonVariant.danger:
        return colorScheme.onError;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return widget.premium ? AppColors.primary700 : colorScheme.primary;
    }
  }

  BorderRadius get _buttonRadius {
    return widget.premium ? AppRadius.md : AppRadius.sm;
  }

  List<BoxShadow> get _premiumShadows {
    if (!widget.premium ||
        !_isEnabled ||
        widget.variant == AppButtonVariant.text) {
      return const [];
    }

    final isOutlined = widget.variant == AppButtonVariant.outlined;

    return [
      BoxShadow(
        color: isOutlined
            ? AppColors.publicShadow.withValues(alpha: _isLifted ? 0.11 : 0.06)
            : AppColors.primary800.withValues(alpha: _isLifted ? 0.22 : 0.13),
        blurRadius: _isLifted ? 24 : 16,
        spreadRadius: _isLifted ? 0.5 : 0,
        offset: Offset(0, _isLifted ? 10 : 6),
      ),
    ];
  }

  double get _height {
    switch (widget.size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
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
    switch (widget.size) {
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
