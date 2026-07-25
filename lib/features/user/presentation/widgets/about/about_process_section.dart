import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutProcessSection extends StatelessWidget {
  const AboutProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const processes = [
      _AboutProcess(
        number: '01',
        title: 'Memilih bahan',
        description: 'Bahan dipilih dan diperiksa sebelum digunakan.',
      ),
      _AboutProcess(
        number: '02',
        title: 'Proses marinasi',
        description: 'Ayam dibumbui agar rasa meresap secara merata.',
      ),
      _AboutProcess(
        number: '03',
        title: 'Dimasak dengan tepat',
        description:
            'Setiap pesanan dimasak untuk menghasilkan tekstur '
            'yang nikmat.',
      ),
      _AboutProcess(
        number: '04',
        title: 'Disajikan hangat',
        description:
            'Pesanan dikemas atau disajikan dengan rapi kepada '
            'pelanggan.',
      ),
    ];

    return AppSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Proses dari Dapur Kami',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tahapan sederhana yang kami jaga untuk '
            'mempertahankan kualitas.',
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
                AppScreenSize.desktop => 4,
                AppScreenSize.wideDesktop => 4,
              };

              final totalSpacing = AppSpacing.md * (columns - 1);
              final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final process in processes)
                    SizedBox(
                      width: cardWidth,
                      child: _AboutProcessCard(process: process),
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

class _AboutProcessCard extends StatelessWidget {
  const _AboutProcessCard({required this.process});

  final _AboutProcess process;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      hoverEnabled: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 155),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              process.number,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              process.title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              process.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutProcess {
  const _AboutProcess({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;
}
