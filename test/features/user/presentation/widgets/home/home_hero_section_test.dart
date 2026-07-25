import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home.dart';

void main() {
  testWidgets('HomeHeroSection executes both CTA actions', (tester) async {
    var menuPressed = false;
    var contactPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeHeroSection(
              onViewMenu: () {
                menuPressed = true;
              },
              onContact: () {
                contactPressed = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Lihat Semua Menu'));
    await tester.pump();

    expect(menuPressed, isTrue);

    await tester.tap(find.text('Hubungi Kami'));
    await tester.pump();

    expect(contactPressed, isTrue);
  });
}
