import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeAboutPreview extends StatelessWidget {
  const HomeAboutPreview({super.key, required this.onReadMore});

  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.xl,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: AppResponsiveBuilder(
          builder: (context, screenSize, constraints) {
            final useDesktopLayout =
                screenSize == AppScreenSize.desktop ||
                screenSize == AppScreenSize.wideDesktop;

            final content = _AboutContent(onReadMore: onReadMore);

            const visual = _AboutVisual();

            if (useDesktopLayout) {
              return Row(
                children: [
                  Expanded(flex: 6, child: content),
                  const SizedBox(width: AppSpacing.sectionSm),
                  const Expanded(flex: 4, child: visual),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                content,
                const SizedBox(height: AppSpacing.xl),
                visual,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _AboutContent extends StatelessWidget {
  const _AboutContent({required this.onReadMore});

  final VoidCallback onReadMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Berakar dari Tradisi,\n'
          'Disajikan untuk Hari Ini.',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Kedai Ayam Nina berawal dari keyakinan sederhana '
          'bahwa ayam goreng bukan sekadar makanan, tetapi '
          'pengalaman yang menyenangkan. Kami menggunakan bahan '
          'pilihan, merendam ayam dengan bumbu hingga meresap, '
          'lalu menggorengnya ketika pesanan diterima.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Dapur kami selalu siap menyajikan makanan hangat '
          'untuk pelanggan. Datang dan rasakan perbedaan dari '
          'setiap menu yang dibuat dengan perhatian.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(
          label: 'Baca Cerita Kami',
          variant: AppButtonVariant.outlined,
          size: AppButtonSize.medium,
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: onReadMore,
        ),
      ],
    );
  }
}

class _AboutVisual extends StatelessWidget {
  const _AboutVisual();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: AppRadius.lg,
        ),
        child: Image.asset(
          Assets.logoC1,
          fit: BoxFit.contain,
          semanticLabel: 'Logo Kedai Ayam Nina',
        ),
      ),
    );
  }
}
