import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

class ProductDetailDescription extends StatelessWidget {
  const ProductDetailDescription({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final description = product.description.trim().isNotEmpty
        ? product.description.trim()
        : 'Informasi lengkap mengenai menu ini belum tersedia.';

    return AppCard(
      premium: true,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer,
                  borderRadius: AppRadius.sm,
                ),
                child: Icon(
                  Icons.notes_rounded,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Tentang menu ini',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
