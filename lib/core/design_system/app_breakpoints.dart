import 'package:flutter/widgets.dart';

/// Kategori ukuran layar yang digunakan secara konsisten oleh aplikasi.
enum AppScreenSize { mobile, tablet, desktop, wideDesktop }

/// Helper untuk membaca karakteristik kategori layar.
extension AppScreenSizeX on AppScreenSize {
  bool get isMobile => this == AppScreenSize.mobile;

  bool get isTablet => this == AppScreenSize.tablet;

  bool get isDesktop {
    return this == AppScreenSize.desktop || this == AppScreenSize.wideDesktop;
  }

  bool get isWideDesktop => this == AppScreenSize.wideDesktop;
}

/// Breakpoint dan aturan responsive global Kedai Ayam Nina.
///
/// Ketentuan:
/// - Mobile: kurang dari 600 px
/// - Tablet: 600–899 px
/// - Desktop: 900–1279 px
/// - Wide desktop: 1280 px atau lebih
class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1280;

  /// Lebar maksimum konten pada desktop biasa.
  static const double contentMaxWidth = 1200;

  /// Lebar maksimum konten pada monitor desktop lebar.
  static const double contentWideMaxWidth = 1440;

  static AppScreenSize screenSizeForWidth(double width) {
    if (width < mobile) {
      return AppScreenSize.mobile;
    }

    if (width < tablet) {
      return AppScreenSize.tablet;
    }

    if (width < desktop) {
      return AppScreenSize.desktop;
    }

    return AppScreenSize.wideDesktop;
  }

  static AppScreenSize screenSizeOf(BuildContext context) {
    return screenSizeForWidth(MediaQuery.sizeOf(context).width);
  }

  static bool isMobileWidth(double width) {
    return width < mobile;
  }

  static bool isTabletWidth(double width) {
    return width >= mobile && width < tablet;
  }

  static bool isDesktopWidth(double width) {
    return width >= tablet;
  }

  static bool isWideDesktopWidth(double width) {
    return width >= desktop;
  }

  static bool isMobile(BuildContext context) {
    return screenSizeOf(context).isMobile;
  }

  static bool isTablet(BuildContext context) {
    return screenSizeOf(context).isTablet;
  }

  static bool isDesktop(BuildContext context) {
    return screenSizeOf(context).isDesktop;
  }

  static bool isWideDesktop(BuildContext context) {
    return screenSizeOf(context).isWideDesktop;
  }

  /// Padding horizontal halaman.
  ///
  /// Padding meningkat secara bertahap agar konten tidak terlalu dekat ke sisi
  /// layar, tetapi juga tidak membuang terlalu banyak ruang pada mobile.
  static double horizontalPadding(double width) {
    switch (screenSizeForWidth(width)) {
      case AppScreenSize.mobile:
        return 20;
      case AppScreenSize.tablet:
        return 32;
      case AppScreenSize.desktop:
        return 48;
      case AppScreenSize.wideDesktop:
        return 64;
    }
  }

  /// Menentukan batas lebar konten berdasarkan ukuran viewport.
  static double contentMaxWidthForWidth(double width) {
    if (isWideDesktopWidth(width)) {
      return contentWideMaxWidth;
    }

    return contentMaxWidth;
  }

  /// Jumlah kolom default untuk grid produk.
  ///
  /// Grid produk akan digunakan lebih lanjut saat redesign halaman Menu.
  static int productGridColumns(double width) {
    if (width < 520) {
      return 1;
    }

    if (width < 850) {
      return 2;
    }

    if (width < 1180) {
      return 3;
    }

    return 4;
  }
}
