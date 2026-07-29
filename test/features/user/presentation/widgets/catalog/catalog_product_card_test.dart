import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/catalog/catalog.dart';

void main() {
  testWidgets('CatalogProductCard displays product and handles tap', (
    tester,
  ) async {
    var tapped = false;

    const product = Product(
      id: 'product-1',
      name: 'Ayam Penyet',
      category: 'Food',
      description: 'Ayam penyet dengan sambal.',
      shortDescription: 'Ayam penyet.',
      price: 25000,
      imageUrl: [],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 340,
              height: 420,
              child: CatalogProductCard(
                product: product,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Ayam Penyet'), findsOneWidget);
    expect(find.text('Makanan'), findsOneWidget);
    expect(find.text('Rp 25.000'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('catalog-product-card-product-1')),
    );

    await tester.pump();

    expect(tapped, isTrue);
  });
}
