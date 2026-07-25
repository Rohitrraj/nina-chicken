import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

void main() {
  testWidgets('AppContentContainer applies mobile horizontal padding', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));

    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: AppContentContainer(child: SizedBox(height: 40))),
    );

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Padding &&
            widget.padding == const EdgeInsets.symmetric(horizontal: 20),
      ),
      findsOneWidget,
    );
  });

  testWidgets('AppContentContainer limits content on wide desktop', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    addTearDown(() => tester.binding.setSurfaceSize(null));

    const contentKey = Key('responsive-content');

    await tester.pumpWidget(
      const MaterialApp(
        home: AppContentContainer(child: SizedBox(key: contentKey, height: 40)),
      ),
    );

    final contentSize = tester.getSize(find.byKey(contentKey));

    expect(contentSize.width, 1440);
  });

  testWidgets('AppContentContainer respects custom max width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 900));

    addTearDown(() => tester.binding.setSurfaceSize(null));

    const contentKey = Key('custom-width-content');

    await tester.pumpWidget(
      const MaterialApp(
        home: AppContentContainer(
          maxWidth: 900,
          child: SizedBox(key: contentKey, height: 40),
        ),
      ),
    );

    final contentSize = tester.getSize(find.byKey(contentKey));

    expect(contentSize.width, 900);
  });
}
