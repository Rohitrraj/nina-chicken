import 'package:flutter/widgets.dart';

class AppBreakpoints {
  const AppBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1280;

  static const double contentMaxWidth = 1200;
  static const double contentWideMaxWidth = 1440;

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
    return isMobileWidth(MediaQuery.sizeOf(context).width);
  }

  static bool isTablet(BuildContext context) {
    return isTabletWidth(MediaQuery.sizeOf(context).width);
  }

  static bool isDesktop(BuildContext context) {
    return isDesktopWidth(MediaQuery.sizeOf(context).width);
  }

  static double horizontalPadding(double width) {
    if (width < mobile) {
      return 20;
    }

    if (width < tablet) {
      return 32;
    }

    if (width < desktop) {
      return 48;
    }

    return 64;
  }

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
