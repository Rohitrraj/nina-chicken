import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';

void main() {
  testWidgets('AppSnackbar displays message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () {
                  AppSnackbar.show(
                    context,
                    message: 'Data berhasil disimpan',
                    type: AppSnackbarType.success,
                  );
                },
                child: const Text('Show snackbar'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Data berhasil disimpan'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
  });
}
