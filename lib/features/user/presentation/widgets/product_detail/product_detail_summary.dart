import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/utils/rupiah_formatter.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

class ProductDetailSummary extends StatelessWidget {
  const ProductDetailSummary({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final category = _formatCategory(product.category);

    final shortDescription = product.shortDescription.trim().isNotEmpty
        ? product.shortDescription.trim()
        : product.description.trim().isNotEmpty
        ? product.description.trim()
        : 'Informasi singkat menu belum tersedia.';

    return AppCard(
      premium: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      semanticLabel: '${product.name}, ${formatRupiah(product.price)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: AppRadius.pill,
            ),
            child: Text(
              category,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            product.name,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.15,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            formatRupiah(product.price),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          const SizedBox(height: AppSpacing.lg),
          Text(
            shortDescription,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  static String _formatCategory(String value) {
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'Menu';
    }

    return trimmed
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) {
          final lowerWord = word.toLowerCase();

          return lowerWord.length == 1
              ? lowerWord.toUpperCase()
              : '${lowerWord[0].toUpperCase()}'
                    '${lowerWord.substring(1)}';
        })
        .join(' ');
  }
}
