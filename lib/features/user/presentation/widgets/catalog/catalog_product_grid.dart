import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/catalog/catalog_product_card.dart';

class CatalogProductGrid extends StatelessWidget {
  const CatalogProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveBuilder(
      builder: (context, screenSize, constraints) {
        final maxCrossAxisExtent = switch (screenSize) {
          AppScreenSize.mobile => 560.0,
          AppScreenSize.tablet => 340.0,
          AppScreenSize.desktop => 380.0,
          AppScreenSize.wideDesktop => 340.0,
        };

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxCrossAxisExtent,
            mainAxisExtent: 420,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return CatalogProductCard(
              product: product,
              onTap: () {
                onProductTap(product);
              },
            );
          },
        );
      },
    );
  }
}
