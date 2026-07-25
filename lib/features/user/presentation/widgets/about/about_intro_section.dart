import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutIntroSection extends StatelessWidget {
  const AboutIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSection(
      spacing: AppSectionSpacing.regular,
      child: AppResponsiveBuilder(
        builder: (context, screenSize, constraints) {
          final useDesktopLayout = screenSize.isDesktop;

          const content = _AboutIntroContent();
          const visual = _AboutIntroVisual();

          if (useDesktopLayout) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 10, child: content),
                SizedBox(width: AppSpacing.xxxl),
                Expanded(flex: 9, child: visual),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              content,
              SizedBox(height: AppSpacing.xxl),
              visual,
            ],
          );
        },
      ),
    );
  }
}

class _AboutIntroContent extends StatelessWidget {
  const _AboutIntroContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final useLargeTitle = AppBreakpoints.isDesktopWidth(viewportWidth);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
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
              'CERITA KEDAI KAMI',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Tentang Kedai Ayam Nina',
            style:
                (useLargeTitle
                        ? theme.textTheme.displaySmall
                        : theme.textTheme.headlineLarge)
                    ?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Kedai Ayam Nina adalah rumah bagi pencinta ayam '
            'goreng. Didirikan di Jakarta Barat pada tahun 2023, '
            'kami berkomitmen menghadirkan makanan yang hangat, '
            'lezat, dan dibuat dengan penuh perhatian.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.65,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Nama Ayam Nina diabadikan dari nama putri tercinta '
            'sebagai simbol kasih sayang dan ketulusan yang '
            'dituangkan ke dalam setiap masakan.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutIntroVisual extends StatelessWidget {
  const _AboutIntroVisual();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      image: true,
      label: 'Suasana tempat makan Kedai Ayam Nina',
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.lg,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.lg,
            child: Image.asset(
              Assets.aboutHero,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
        ),
      ),
    );
  }
}
