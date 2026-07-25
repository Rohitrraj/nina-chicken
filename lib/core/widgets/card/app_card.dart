import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

/// Surface card reusable untuk halaman publik dan admin.
///
/// [premium] bersifat opt-in agar storefront publik dapat memakai
/// surface hangat dan hover refined tanpa mengubah halaman admin.
class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = AppRadius.md,
    this.hoverEnabled = true,
    this.semanticLabel,
    this.clipBehavior = Clip.antiAlias,
    this.premium = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius borderRadius;
  final bool hoverEnabled;
  final String? semanticLabel;
  final Clip clipBehavior;

  /// Mengaktifkan surface warm ivory, border refined,
  /// shadow hangat, dan hover lift dua pixel.
  final bool premium;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;
  bool _focused = false;

  bool get _shouldElevate {
    return widget.onTap != null &&
        widget.hoverEnabled &&
        (_hovered || _focused);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final usesPremiumLightSurface =
        widget.premium && theme.brightness == Brightness.light;

    final effectiveBackground =
        widget.backgroundColor ??
        (usesPremiumLightSurface
            ? AppColors.publicSurface
            : colorScheme.surface);

    final effectiveBorder =
        widget.borderColor ??
        (usesPremiumLightSurface
            ? AppColors.publicBorder
            : colorScheme.outlineVariant);

    return Semantics(
      container: true,
      button: widget.onTap != null,
      label: widget.semanticLabel,
      child: Padding(
        padding: widget.margin,
        child: Focus(
          onFocusChange: (focused) {
            if (_focused != focused) {
              setState(() {
                _focused = focused;
              });
            }
          },
          child: MouseRegion(
            onEnter: (_) {
              if (widget.onTap != null && widget.hoverEnabled) {
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
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 190),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(end: _shouldElevate ? 1 : 0),
              builder: (context, progress, child) {
                final material = Material(
                  color: effectiveBackground,
                  elevation: widget.premium ? 0 : 5 * progress,
                  shadowColor: theme.shadowColor.withValues(alpha: 0.14),
                  clipBehavior: widget.clipBehavior,
                  shape: RoundedRectangleBorder(
                    borderRadius: widget.borderRadius,
                    side: BorderSide(
                      color: effectiveBorder,
                      width: widget.premium ? 1 : 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: widget.onTap,
                    mouseCursor: widget.onTap == null
                        ? SystemMouseCursors.basic
                        : SystemMouseCursors.click,
                    borderRadius: widget.borderRadius,
                    child: child,
                  ),
                );

                if (!widget.premium) {
                  return material;
                }

                return Transform.translate(
                  offset: Offset(0, -2 * progress),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: widget.borderRadius,
                      boxShadow: [
                        BoxShadow(
                          color:
                              (theme.brightness == Brightness.light
                                      ? AppColors.publicShadow
                                      : Colors.black)
                                  .withValues(alpha: 0.07 + (0.07 * progress)),
                          blurRadius: 18 + (10 * progress),
                          spreadRadius: 0.2 * progress,
                          offset: Offset(0, 6 + (4 * progress)),
                        ),
                      ],
                    ),
                    child: material,
                  ),
                );
              },
              child: Padding(padding: widget.padding, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
