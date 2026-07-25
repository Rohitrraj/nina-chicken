import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';

void main() {
  testWidgets('ProductDetailUnavailableView returns to catalog', (
    tester,
  ) async {
    var pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: ProductDetailUnavailableView(
            onBackToCatalog: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Produk tidak tersedia'), findsOneWidget);

    await tester.tap(find.text('Kembali ke Menu'));
    await tester.pump();

    expect(pressed, isTrue);
  });
}
