import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';

void main() {
  testWidgets('ProductDetailSummary displays normalized product information', (
    tester,
  ) async {
    const product = Product(
      id: 'product-1',
      name: 'Ayam Penyet',
      category: 'food',
      description: 'Ayam dengan sambal.',
      shortDescription: 'Ayam penyet rumahan.',
      price: 25000,
      imageUrl: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: SizedBox(
            width: 440,
            child: ProductDetailSummary(product: product),
          ),
        ),
      ),
    );

    expect(find.text('Ayam Penyet'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Rp 25.000'), findsOneWidget);
    expect(find.text('Ayam penyet rumahan.'), findsOneWidget);
  });
}
