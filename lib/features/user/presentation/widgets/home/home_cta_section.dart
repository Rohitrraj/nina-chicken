import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeCtaSection extends StatelessWidget {
  const HomeCtaSection({
    super.key,
    required this.onViewMenu,
    required this.onContact,
  });

  final VoidCallback onViewMenu;
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
                  'Sudah menemukan menu yang menarik?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Lihat seluruh katalog atau hubungi '
                  'Kedai Ayam Nina untuk informasi lebih lanjut.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer.withValues(
                      alpha: 0.8,
                    ),
                    height: 1.5,
                  ),
                ),
              ],
            );

            final actions = _CtaActions(
              horizontal: useHorizontalLayout,
              onViewMenu: onViewMenu,
              onContact: onContact,
            );

            if (useHorizontalLayout) {
              return Row(
                children: [
                  Expanded(child: content),
                  const SizedBox(width: AppSpacing.xl),
                  actions,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: AppSpacing.lg),
                actions,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CtaActions extends StatelessWidget {
  const _CtaActions({
    required this.horizontal,
    required this.onViewMenu,
    required this.onContact,
  });

  final bool horizontal;
  final VoidCallback onViewMenu;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final children = [
      AppButton(
        label: 'Lihat Semua Menu',
        variant: AppButtonVariant.primary,
        size: AppButtonSize.medium,
        onPressed: onViewMenu,
      ),
      AppButton(
        label: 'Hubungi Kami',
        variant: AppButtonVariant.outlined,
        size: AppButtonSize.medium,
        onPressed: onContact,
      ),
    ];

    if (horizontal) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: children,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: double.infinity, child: children[0]),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(width: double.infinity, child: children[1]),
      ],
    );
  }
}
