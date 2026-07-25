import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';

/// Container responsive untuk membatasi lebar konten halaman.
///
/// Komponen ini menangani:
/// - padding horizontal responsive;
/// - lebar maksimum konten;
/// - alignment konten;
/// - perilaku full-width di dalam batas yang ditentukan.
///
/// Gunakan komponen ini sebagai pembungkus utama isi navbar, section,
/// halaman Menu, About, Contact, dan dashboard.
class AppContentContainer extends StatelessWidget {
  const AppContentContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;

  /// Override lebar maksimum konten.
  ///
  /// Apabila null, nilai akan mengikuti AppBreakpoints.
  final double? maxWidth;

  /// Override padding container.
  ///
  /// Apabila null, padding horizontal akan dihitung secara responsive.
  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final effectiveMaxWidth =
            maxWidth ?? AppBreakpoints.contentMaxWidthForWidth(viewportWidth);

        final effectivePadding =
            padding ??
            EdgeInsets.symmetric(
              horizontal: AppBreakpoints.horizontalPadding(viewportWidth),
            );

        return Padding(
          padding: effectivePadding,
          child: Align(
            alignment: alignment,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
              child: SizedBox(width: double.infinity, child: child),
            ),
          ),
        );
      },
    );
  }
}
