import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home.dart';

void main() {
  testWidgets('HomeCtaSection only displays contact action', (tester) async {
    var contactPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: HomeCtaSection(
            onContact: () {
              contactPressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Lihat Semua Menu'), findsNothing);
    expect(find.text('Hubungi Kami'), findsNWidgets(2));

    final contactButton = find.widgetWithText(OutlinedButton, 'Hubungi Kami');

    expect(contactButton, findsOneWidget);

    await tester.tap(contactButton);
    await tester.pump();

    expect(contactPressed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
