import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';

void main() {
  testWidgets('AppButton calls callback when pressed', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppButton(
            label: 'Simpan',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Simpan'));
    await tester.pump();

    expect(pressed, isTrue);
  });

  testWidgets('AppButton disables interaction while loading', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppButton(
            label: 'Menyimpan',
            isLoading: true,
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.tap(find.text('Menyimpan'));
    await tester.pump();

    expect(pressed, isFalse);
  });

  testWidgets('AppButton supports full width', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    addTearDown(() => tester.binding.setSurfaceSize(null));

    const buttonKey = Key('full-width-button');

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(20),
            child: AppButton(
              key: buttonKey,
              label: 'Masuk',
              fullWidth: true,
              onPressed: _emptyCallback,
            ),
          ),
        ),
      ),
    );

    final size = tester.getSize(find.byKey(buttonKey));

    expect(size.width, 360);
  });
}

void _emptyCallback() {}
