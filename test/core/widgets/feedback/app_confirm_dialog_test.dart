import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';

void main() {
  testWidgets('AppConfirmDialog returns true after confirmation', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () async {
                  result = await AppConfirmDialog.show(
                    context,
                    title: 'Hapus produk?',
                    message: 'Produk yang dihapus tidak dapat dikembalikan.',
                    confirmLabel: 'Hapus',
                    destructive: true,
                  );
                },
                child: const Text('Open dialog'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open dialog'));
    await tester.pumpAndSettle();

    expect(find.text('Hapus produk?'), findsOneWidget);

    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });
}
