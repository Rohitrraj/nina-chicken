import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/feedback/feedback.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/home/home_product_card.dart';

enum HomeFeaturedMenuStatus { loading, loaded, empty, error }

class HomeFeaturedMenuSection extends StatelessWidget {
  const HomeFeaturedMenuSection.loading({super.key, required this.onViewAll})
    : status = HomeFeaturedMenuStatus.loading,
      products = const <Product>[],
      onProductTap = null,
      onRetry = null;

  const HomeFeaturedMenuSection.loaded({
    super.key,
    required this.products,
    required this.onProductTap,
    required this.onViewAll,
  }) : status = HomeFeaturedMenuStatus.loaded,
       onRetry = null;

  const HomeFeaturedMenuSection.empty({super.key, required this.onViewAll})
    : status = HomeFeaturedMenuStatus.empty,
      products = const <Product>[],
      onProductTap = null,
      onRetry = null;

  const HomeFeaturedMenuSection.error({
    super.key,
    required this.onViewAll,
    required this.onRetry,
  }) : status = HomeFeaturedMenuStatus.error,
       products = const <Product>[],
       onProductTap = null;

  final HomeFeaturedMenuStatus status;
  final List<Product> products;
  final ValueChanged<Product>? onProductTap;
  final VoidCallback onViewAll;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppResponsiveBuilder(
            builder: (context, screenSize, constraints) {
              final useHorizontalHeader =
                  screenSize == AppScreenSize.desktop ||
                  screenSize == AppScreenSize.wideDesktop;

              final title = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menu Pilihan',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Beberapa menu yang dapat kamu lihat sebelum '
                    'menjelajahi katalog lengkap.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              );

              final action = AppButton(
                label: 'Lihat Menu Lengkap',
                variant: AppButtonVariant.text,
                size: AppButtonSize.small,
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: onViewAll,
              );

              if (useHorizontalHeader) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: title),
                    const SizedBox(width: AppSpacing.lg),
                    action,
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  const SizedBox(height: AppSpacing.sm),
                  action,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    switch (status) {
      case HomeFeaturedMenuStatus.loading:
        return const AppLoadingView(
          compact: true,
          message: 'Memuat menu pilihan...',
        );

      case HomeFeaturedMenuStatus.empty:
        return const AppFeedbackView.empty(
          compact: true,
          title: 'Menu belum tersedia',
          message: 'Daftar menu Kedai Ayam Nina masih kosong.',
        );

      case HomeFeaturedMenuStatus.error:
        return AppFeedbackView.error(
          compact: true,
          title: 'Gagal memuat menu',
          message: 'Terjadi kendala saat mengambil daftar menu.',
          onAction: onRetry,
        );

      case HomeFeaturedMenuStatus.loaded:
        return _FeaturedProductGrid(
          products: products,
          onProductTap: onProductTap!,
        );
    }
  }
}

class _FeaturedProductGrid extends StatelessWidget {
  const _FeaturedProductGrid({
    required this.products,
    required this.onProductTap,
  });

  final List<Product> products;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return AppResponsiveBuilder(
      builder: (context, screenSize, constraints) {
        final maxItems = switch (screenSize) {
          AppScreenSize.mobile => 2,
          AppScreenSize.tablet => 3,
          AppScreenSize.desktop => 3,
          AppScreenSize.wideDesktop => 4,
        };

        final visibleProducts = products.take(maxItems).toList();

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleProducts.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisExtent: 420,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
          ),
          itemBuilder: (context, index) {
            final product = visibleProducts[index];

            return HomeProductCard(
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
