import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({super.key, required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      spacing: AppSectionSpacing.compact,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: AppRadius.xl,
        ),
        child: AppResponsiveBuilder(
          builder: (context, screenSize, constraints) {
            final useHorizontalLayout =
                screenSize == AppScreenSize.desktop ||
                screenSize == AppScreenSize.wideDesktop;

            final content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hubungi Kami',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Punya pertanyaan, pesanan khusus, atau masukan? '
                  'Jangan ragu untuk menghubungi kami.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                    height: 1.5,
                  ),
                ),
              ],
            );

            final action = AppButton(
              premium: true,
              label: 'Hubungi Kami',
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.medium,
              onPressed: onContact,
            );

            if (useHorizontalLayout) {
              return Row(
                children: [
                  Expanded(child: content),
                  const SizedBox(width: AppSpacing.xl),
                  action,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: AppSpacing.lg),
                SizedBox(width: double.infinity, child: action),
              ],
            );
          },
        ),
      ),
    );
  }
}
