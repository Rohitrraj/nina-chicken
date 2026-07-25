import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class ContactHeaderSection extends StatelessWidget {
  const ContactHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      backgroundColor: AppColors.tertiary700,
      spacing: AppSectionSpacing.regular,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.textOnDark.withValues(alpha: 0.12),
                borderRadius: AppRadius.pill,
                border: Border.all(
                  color: AppColors.textOnDark.withValues(alpha: 0.16),
                ),
              ),
              child: Text(
                'KONTAK KEDAI',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.textOnDark,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Hubungi Kedai Ayam Nina',
              style: theme.textTheme.displaySmall?.copyWith(
                color: AppColors.textOnDark,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Punya pertanyaan mengenai menu atau informasi '
              'Kedai Ayam Nina? Gunakan informasi kontak yang '
              'tersedia atau siapkan pesan melalui form berikut.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textOnDark.withValues(alpha: 0.82),
                height: 1.65,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
