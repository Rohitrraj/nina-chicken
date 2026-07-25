import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class ProductDetailHeader extends StatelessWidget {
  const ProductDetailHeader({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      spacing: AppSectionSpacing.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButton(
            label: 'Kembali ke Menu',
            variant: AppButtonVariant.text,
            size: AppButtonSize.small,
            leadingIcon: Icons.arrow_back_rounded,
            onPressed: onBack,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Detail Produk',
            style: theme.textTheme.displaySmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.1,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Lihat informasi lengkap mengenai menu yang dipilih.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
