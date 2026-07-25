import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home.dart';

void main() {
  const products = [
    Product(
      id: 'product-1',
      name: 'Ayam Geprek Original',
      category: 'Food',
      description: 'Ayam geprek dengan sambal.',
      shortDescription: 'Ayam geprek original.',
      price: 18000,
      imageUrl: [],
    ),
    Product(
      id: 'product-2',
      name: 'Es Teh',
      category: 'Beverage',
      description: 'Minuman teh dingin.',
      shortDescription: 'Es teh segar.',
      price: 5000,
      imageUrl: [],
    ),
  ];

  testWidgets('HomeFeaturedMenuSection displays loaded products', (
    tester,
  ) async {
    Product? selectedProduct;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: HomeFeaturedMenuSection.loaded(
              products: products,
              onViewAll: () {},
              onProductTap: (product) {
                selectedProduct = product;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Ayam Geprek Original'), findsOneWidget);
    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.text('Rp 18.000'), findsOneWidget);

    final firstProductCard = find.byKey(
      const ValueKey<String>('home-product-card-product-1'),
    );

    expect(firstProductCard, findsOneWidget);

    await tester.ensureVisible(firstProductCard);
    await tester.pumpAndSettle();

    await tester.tap(firstProductCard);
    await tester.pump();

    expect(selectedProduct?.id, 'product-1');
  });

  testWidgets('HomeFeaturedMenuSection displays empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(body: HomeFeaturedMenuSection.empty(onViewAll: () {})),
      ),
    );

    expect(find.text('Menu belum tersedia'), findsOneWidget);
  });
}
