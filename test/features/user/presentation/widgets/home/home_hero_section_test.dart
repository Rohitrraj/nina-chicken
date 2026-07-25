import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home.dart';

void main() {
  testWidgets('HomeHeroSection displays logo and executes menu action', (
    tester,
  ) async {
    var menuPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeHeroSection(
              onViewMenu: () {
                menuPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    final logo = find.byWidgetPredicate((widget) {
      if (widget is! Image) {
        return false;
      }

      final image = widget.image;

      return image is AssetImage && image.assetName == Assets.logoC1;
    });

    expect(logo, findsWidgets);
    expect(find.text('Lihat Semua Menu'), findsOneWidget);
    expect(find.text('Hubungi Kami'), findsNothing);

    await tester.tap(find.text('Lihat Semua Menu'));
    await tester.pump();

    expect(menuPressed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
