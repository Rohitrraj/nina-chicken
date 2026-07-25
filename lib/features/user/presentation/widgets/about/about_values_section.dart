import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutValuesSection extends StatelessWidget {
  const AboutValuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const values = [
      _AboutValue(
        icon: Icons.eco_rounded,
        title: 'Bahan Pilihan',
        description:
            'Bahan dipilih dengan teliti untuk menjaga rasa dan '
            'kualitas setiap menu.',
      ),
      _AboutValue(
        icon: Icons.local_fire_department_rounded,
        title: 'Dimasak Saat Dipesan',
        description:
            'Makanan disiapkan agar tetap hangat dan nikmat saat '
            'diterima pelanggan.',
      ),
      _AboutValue(
        icon: Icons.favorite_rounded,
        title: 'Resep Penuh Ketulusan',
        description:
            'Setiap hidangan dibuat dengan resep yang konsisten '
            'dan penuh perhatian.',
      ),
    ];

    return AppSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mengapa Memilih Kami?',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Kami berusaha memberikan pengalaman makan yang '
            'sederhana, nyaman, dan berkesan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppResponsiveBuilder(
            builder: (context, screenSize, constraints) {
              final columns = switch (screenSize) {
                AppScreenSize.mobile => 1,
                AppScreenSize.tablet => 2,
                AppScreenSize.desktop => 3,
                AppScreenSize.wideDesktop => 3,
              };

              final totalSpacing = AppSpacing.lg * (columns - 1);
              final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

              return Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: [
                  for (final value in values)
                    SizedBox(
                      width: cardWidth,
                      child: _AboutValueCard(value: value),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutValueCard extends StatelessWidget {
  const _AboutValueCard({required this.value});

  final _AboutValue value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      premium: true,
      hoverEnabled: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: AppRadius.sm,
              ),
              child: Icon(
                value.icon,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              value.title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutValue {
  const _AboutValue({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}
