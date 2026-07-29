import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

import 'package:kedai_ayam_nina/core/widgets/images/optimized_network_image.dart';

class CatalogProductCard extends StatelessWidget {
  const CatalogProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final category = product.category.trim().isEmpty
        ? 'Menu'
        : product.category.trim();

    final description = product.shortDescription.trim().isNotEmpty
        ? product.shortDescription.trim()
        : product.description.trim();

    return AppCard(
      premium: true,
      key: ValueKey<String>('catalog-product-card-${product.id}'),
      padding: EdgeInsets.zero,
      onTap: onTap,
      semanticLabel: '${product.name}, ${_formatRupiah(product.price)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _CatalogProductImage(
              productName: product.name,
              imageUrls: product.imageUrl,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: AppRadius.pill,
                    ),
                    child: Text(
                      category,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _formatRupiah(product.price),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: AppRadius.sm,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: 19,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatRupiah(double value) {
    final digits = value.round().toString();
    final reversed = digits.split('').reversed.toList();
    final buffer = StringBuffer();

    for (var index = 0; index < reversed.length; index++) {
      if (index > 0 && index % 3 == 0) {
        buffer.write('.');
      }

      buffer.write(reversed[index]);
    }

    final formatted = buffer.toString().split('').reversed.join();

    return 'Rp $formatted';
  }
}

class _CatalogProductImage extends StatelessWidget {
  const _CatalogProductImage({
    required this.productName,
    required this.imageUrls,
  });

  final String productName;
  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    final imageUrl = imageUrls
        .map((url) => url.trim())
        .where((url) => url.isNotEmpty)
        .firstOrNull;

    if (imageUrl == null) {
      return const _CatalogProductImageFallback();
    }

    return Semantics(
      image: true,
      label: 'Foto $productName',
      child: OptimizedNetworkImage(
        imageUrl,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return const _CatalogProductImageLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return const _CatalogProductImageFallback();
        },
      ),
    );
  }
}

class _CatalogProductImageLoading extends StatelessWidget {
  const _CatalogProductImageLoading();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: const Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}

class _CatalogProductImageFallback extends StatelessWidget {
  const _CatalogProductImageFallback();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Opacity(
            opacity: 0.55,
            child: Image.asset(
              Assets.logoC1,
              fit: BoxFit.contain,
              semanticLabel: 'Logo Kedai Ayam Nina',
            ),
          ),
        ),
      ),
    );
  }
}
