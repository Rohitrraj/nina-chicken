import 'package:flutter/widgets.dart';
import 'package:kedai_ayam_nina/core/design_system/app_breakpoints.dart';

typedef AppResponsiveWidgetBuilder =
    Widget Function(
      BuildContext context,
      AppScreenSize screenSize,
      BoxConstraints constraints,
    );

/// LayoutBuilder dengan kategori layar yang sudah distandardisasi.
///
/// Komponen ini digunakan ketika struktur widget benar-benar perlu berubah,
/// misalnya navbar desktop menjadi drawer pada mobile atau hero Row menjadi
/// Column.
///
/// Untuk perubahan ukuran sederhana, tetap gunakan Flexible, Expanded,
/// Wrap, dan constraint sebelum membuat banyak percabangan responsive.
class AppResponsiveBuilder extends StatelessWidget {
  const AppResponsiveBuilder({super.key, required this.builder});

  final AppResponsiveWidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final screenSize = AppBreakpoints.screenSizeForWidth(viewportWidth);

        return builder(context, screenSize, constraints);
      },
    );
  }
}
