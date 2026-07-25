import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';

void main() {
  testWidgets('AppLoadingView displays progress indicator', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(body: AppLoadingView(message: 'Memuat data...')),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Memuat data...'), findsOneWidget);
  });

  testWidgets('AppFeedbackView error executes retry action', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: AppFeedbackView.error(
            title: 'Gagal memuat',
            message: 'Silakan coba lagi.',
            onAction: () {
              retried = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Gagal memuat'), findsOneWidget);
    expect(find.text('Silakan coba lagi.'), findsOneWidget);

    await tester.tap(find.text('Coba lagi'));
    await tester.pump();

    expect(retried, isTrue);
  });
}
