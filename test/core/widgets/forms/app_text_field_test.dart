import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/forms/forms.dart';

void main() {
  testWidgets('AppTextField displays label and hint', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: AppTextField(label: 'Email', hintText: 'Masukkan email'),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Masukkan email'), findsOneWidget);
  });

  testWidgets('AppTextField executes validator', (tester) async {
    final formKey = GlobalKey<FormState>();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Form(
            key: formKey,
            child: AppTextField(
              label: 'Nama',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama wajib diisi';
                }

                return null;
              },
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), isFalse);

    await tester.pump();

    expect(find.text('Nama wajib diisi'), findsOneWidget);
  });
}
