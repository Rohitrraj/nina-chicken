import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutHighlightStrip extends StatelessWidget {
  const AboutHighlightStrip({super.key});

  @override
  Widget build(BuildContext context) {
    const highlights = [
      _AboutHighlight(value: '2023', label: 'Tahun berdiri'),
      _AboutHighlight(value: '10+', label: 'Pilihan menu'),
      _AboutHighlight(value: '100%', label: 'Bahan dipilih'),
      _AboutHighlight(value: 'Setiap Hari', label: 'Dimasak segar'),
    ];

    return AppSection(
      spacing: AppSectionSpacing.compact,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: const BoxDecoration(
          color: AppColors.tertiary700,
          borderRadius: AppRadius.lg,
        ),
        child: AppResponsiveBuilder(
          builder: (context, screenSize, constraints) {
            final columns = screenSize.isDesktop ? 4 : 2;
            final totalSpacing = AppSpacing.md * (columns - 1);
            final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

            return Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.xl,
              children: [
                for (final highlight in highlights)
                  SizedBox(
                    width: itemWidth,
                    child: _AboutHighlightItem(highlight: highlight),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AboutHighlightItem extends StatelessWidget {
  const _AboutHighlightItem({required this.highlight});

  final _AboutHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: '${highlight.value}, ${highlight.label}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            highlight.value,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColors.textOnDark,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            highlight.label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textOnDark.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutHighlight {
  const _AboutHighlight({required this.value, required this.label});

  final String value;
  final String label;
}
