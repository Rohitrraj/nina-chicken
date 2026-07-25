import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/product_detail/product_detail.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_drawer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_footer.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navbar.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class DetailProductUserPage extends StatelessWidget {
  const DetailProductUserPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: isDesktop ? null : const UserDrawer(),
      body: CustomScrollView(
        slivers: [
          UserNavBar(isDesktop: isDesktop),
          SliverToBoxAdapter(
            child: ProductDetailHeader(
              onBack: () {
                _handleBack(context);
              },
            ),
          ),
          SliverToBoxAdapter(
            child: AppSection(
              spacing: AppSectionSpacing.compact,
              backgroundColor: theme.colorScheme.surface,
              child: AppResponsiveBuilder(
                builder: (context, screenSize, constraints) {
                  final content = _ProductDetailInformation(
                    product: product,
                    onViewMenu: () {
                      context.goNamed(MyRoute.catalog.name);
                    },
                  );

                  if (screenSize.isDesktop) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 11,
                          child: ProductDetailGallery(
                            productName: product.name,
                            imageUrls: product.imageUrl,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sectionSm),
                        Expanded(flex: 9, child: content),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProductDetailGallery(
                        productName: product.name,
                        imageUrls: product.imageUrl,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      content,
                    ],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(child: UserFooter(isDesktop: isDesktop)),
        ],
      ),
    );
  }

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.goNamed(MyRoute.catalog.name);
  }
}

class _ProductDetailInformation extends StatelessWidget {
  const _ProductDetailInformation({
    required this.product,
    required this.onViewMenu,
  });

  final Product product;
  final VoidCallback onViewMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProductDetailSummary(product: product),
        const SizedBox(height: AppSpacing.lg),
        ProductDetailDescription(product: product),
        const SizedBox(height: AppSpacing.lg),
        ProductDetailActions(onViewMenu: onViewMenu),
      ],
    );
  }
}
