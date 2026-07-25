import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/design_system/app_breakpoints.dart';

void main() {
  group('AppBreakpoints.screenSizeForWidth', () {
    test('returns mobile below 600 px', () {
      expect(AppBreakpoints.screenSizeForWidth(599), AppScreenSize.mobile);
    });

    test('returns tablet from 600 px', () {
      expect(AppBreakpoints.screenSizeForWidth(600), AppScreenSize.tablet);

      expect(AppBreakpoints.screenSizeForWidth(899), AppScreenSize.tablet);
    });

    test('returns desktop from 900 px', () {
      expect(AppBreakpoints.screenSizeForWidth(900), AppScreenSize.desktop);

      expect(AppBreakpoints.screenSizeForWidth(1279), AppScreenSize.desktop);
    });

    test('returns wide desktop from 1280 px', () {
      expect(
        AppBreakpoints.screenSizeForWidth(1280),
        AppScreenSize.wideDesktop,
      );
    });
  });

  group('AppBreakpoints.horizontalPadding', () {
    test('returns responsive page padding', () {
      expect(AppBreakpoints.horizontalPadding(390), 20);
      expect(AppBreakpoints.horizontalPadding(768), 32);
      expect(AppBreakpoints.horizontalPadding(1024), 48);
      expect(AppBreakpoints.horizontalPadding(1440), 64);
    });
  });

  group('AppBreakpoints.productGridColumns', () {
    test('returns responsive product grid columns', () {
      expect(AppBreakpoints.productGridColumns(390), 1);
      expect(AppBreakpoints.productGridColumns(700), 2);
      expect(AppBreakpoints.productGridColumns(1024), 3);
      expect(AppBreakpoints.productGridColumns(1440), 4);
    });
  });

  group('AppBreakpoints.contentMaxWidthForWidth', () {
    test('uses regular max width below wide desktop', () {
      expect(
        AppBreakpoints.contentMaxWidthForWidth(1024),
        AppBreakpoints.contentMaxWidth,
      );
    });

    test('uses wide max width on wide desktop', () {
      expect(
        AppBreakpoints.contentMaxWidthForWidth(1440),
        AppBreakpoints.contentWideMaxWidth,
      );
    });
  });
}
