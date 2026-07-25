import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';

void main() {
  testWidgets('AppCard displays its child', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(body: AppCard(child: Text('Card content'))),
      ),
    );

    expect(find.text('Card content'), findsOneWidget);
  });

  testWidgets('AppCard calls onTap', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Clickable card'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Clickable card'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
