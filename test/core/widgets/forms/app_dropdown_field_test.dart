import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/forms/forms.dart';

void main() {
  testWidgets('AppDropdownField displays selected value', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppDropdownField<String>(
            label: 'Kategori',
            value: 'food',
            items: const [
              AppDropdownItem(value: 'food', label: 'Makanan'),
              AppDropdownItem(value: 'drink', label: 'Minuman'),
            ],
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Makanan'), findsOneWidget);
  });
}
