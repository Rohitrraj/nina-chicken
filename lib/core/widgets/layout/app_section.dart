import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/app_content_container.dart';

/// Tingkat jarak vertikal sebuah section.
enum AppSectionSpacing { compact, regular, spacious }

/// Pembungkus section halaman publik.
///
/// Background memenuhi seluruh lebar viewport, sedangkan isi section tetap
/// dibatasi menggunakan AppContentContainer.
class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.child,
    this.backgroundColor,
    this.spacing = AppSectionSpacing.regular,
    this.padding,
    this.contentPadding,
    this.contentMaxWidth,
  });

  final Widget child;

  /// Warna background section yang memenuhi seluruh viewport.
  final Color? backgroundColor;

  /// Preset jarak vertikal responsive.
  final AppSectionSpacing spacing;

  /// Override seluruh padding section.
  ///
  /// Ketika diberikan, preset [spacing] tidak digunakan.
  final EdgeInsetsGeometry? padding;

  /// Override padding AppContentContainer.
  final EdgeInsetsGeometry? contentPadding;

  /// Override lebar maksimum isi section.
  final double? contentMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final effectivePadding =
            padding ??
            EdgeInsets.symmetric(vertical: _verticalPadding(viewportWidth));

        return ColoredBox(
          color: backgroundColor ?? Colors.transparent,
          child: Padding(
            padding: effectivePadding,
            child: AppContentContainer(
              maxWidth: contentMaxWidth,
              padding: contentPadding,
              child: child,
            ),
          ),
        );
      },
    );
  }

  double _verticalPadding(double width) {
    final screenSize = AppBreakpoints.screenSizeForWidth(width);

    switch (spacing) {
      case AppSectionSpacing.compact:
        switch (screenSize) {
          case AppScreenSize.mobile:
            return AppSpacing.xl;
          case AppScreenSize.tablet:
            return AppSpacing.xxl;
          case AppScreenSize.desktop:
            return AppSpacing.xxxl;
          case AppScreenSize.wideDesktop:
            return AppSpacing.sectionSm;
        }

      case AppSectionSpacing.regular:
        switch (screenSize) {
          case AppScreenSize.mobile:
            return AppSpacing.sectionSm;
          case AppScreenSize.tablet:
            return AppSpacing.sectionMd;
          case AppScreenSize.desktop:
            return AppSpacing.sectionLg;
          case AppScreenSize.wideDesktop:
            return AppSpacing.sectionXl;
        }

      case AppSectionSpacing.spacious:
        switch (screenSize) {
          case AppScreenSize.mobile:
            return AppSpacing.sectionMd;
          case AppScreenSize.tablet:
            return AppSpacing.sectionLg;
          case AppScreenSize.desktop:
          case AppScreenSize.wideDesktop:
            return AppSpacing.sectionXl;
        }
    }
  }
}
