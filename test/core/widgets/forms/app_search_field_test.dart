import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/forms/forms.dart';

void main() {
  testWidgets('AppSearchField emits search text', (tester) async {
    String? query;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppSearchField(
            onChanged: (value) {
              query = value;
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'ayam geprek');

    expect(query, 'ayam geprek');
  });

  testWidgets('AppSearchField clears current query', (tester) async {
    final controller = TextEditingController(text: 'ayam');

    addTearDown(controller.dispose);

    String? query;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppSearchField(
            controller: controller,
            onChanged: (value) {
              query = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();

    expect(controller.text, isEmpty);
    expect(query, isEmpty);
  });
}
