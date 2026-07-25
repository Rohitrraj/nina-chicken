import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';

void main() {
  testWidgets('ProductDetailGallery changes selected image', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: Scaffold(
          body: SizedBox(
            width: 520,
            child: ProductDetailGallery(
              productName: 'Ayam Penyet',
              imageUrls: const ['image-one', 'image-two'],
              imageBuilder: (context, imageUrl, fit) {
                return ColoredBox(
                  color: Colors.transparent,
                  child: Center(child: Text(imageUrl)),
                );
              },
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('product-detail-main-image-0')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('product-detail-thumbnail-1')),
    );

    await tester.pump();

    expect(
      find.byKey(const ValueKey<String>('product-detail-main-image-1')),
      findsOneWidget,
    );
  });

  testWidgets('ProductDetailGallery displays fallback without images', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme(),
        home: const Scaffold(
          body: SizedBox(
            width: 420,
            child: ProductDetailGallery(
              productName: 'Ayam Penyet',
              imageUrls: [],
            ),
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('product-detail-image-fallback')),
      findsOneWidget,
    );
  });
}
