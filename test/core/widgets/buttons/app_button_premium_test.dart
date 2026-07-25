import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

void main() {
  testWidgets('premium primary button uses subtle gradient', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Center(
            child: AppButton(
              label: 'Lihat Menu',
              premium: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        ),
      ),
    );

    final gradientSurface = find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) {
        return false;
      }

      final decoration = widget.decoration;

      return decoration is BoxDecoration &&
          decoration.gradient is LinearGradient;
    });

    expect(gradientSurface, findsOneWidget);

    await tester.tap(find.text('Lihat Menu'));
    await tester.pump();

    expect(pressed, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('standard button does not enable premium gradient', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Center(
            child: AppButton(label: 'Admin Action', onPressed: () {}),
          ),
        ),
      ),
    );

    final gradientSurface = find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) {
        return false;
      }

      final decoration = widget.decoration;

      return decoration is BoxDecoration &&
          decoration.gradient is LinearGradient;
    });

    expect(gradientSurface, findsNothing);
    expect(tester.takeException(), isNull);
  });
}
