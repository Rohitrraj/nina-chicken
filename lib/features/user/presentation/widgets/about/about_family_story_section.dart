import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutFamilyStorySection extends StatelessWidget {
  const AboutFamilyStorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.xl,
        ),
        child: AppResponsiveBuilder(
          builder: (context, screenSize, constraints) {
            const visual = _FamilyStoryVisual();
            const content = _FamilyStoryContent();

            if (screenSize.isDesktop) {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 10, child: visual),
                  SizedBox(width: AppSpacing.xl),
                  Expanded(flex: 10, child: content),
                ],
              );
            }

            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                visual,
                SizedBox(height: AppSpacing.xl),
                content,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FamilyStoryVisual extends StatelessWidget {
  const _FamilyStoryVisual();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Hidangan ayam dari dapur Kedai Ayam Nina',
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: ClipRRect(
          borderRadius: AppRadius.lg,
          child: Image.asset(
            Assets.aboutFamilyStory,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            excludeFromSemantics: true,
          ),
        ),
      ),
    );
  }
}

class _FamilyStoryContent extends StatelessWidget {
  const _FamilyStoryContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berawal dari Dapur Keluarga',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Kedai Ayam Nina bermula dari kebiasaan memasak '
          'untuk keluarga. Resep yang disukai orang terdekat '
          'kemudian dikembangkan menjadi menu yang dapat '
          'dinikmati lebih banyak pelanggan.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.65,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Kami percaya bahwa makanan yang baik tidak harus '
          'rumit. Yang terpenting adalah bahan yang tepat, '
          'proses yang terjaga, dan pelayanan yang tulus.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}
