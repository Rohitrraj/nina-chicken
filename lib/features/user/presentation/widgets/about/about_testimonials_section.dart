import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class AboutTestimonialsSection extends StatelessWidget {
  const AboutTestimonialsSection({super.key});

  static const _reviews = [
    _CustomerReview(
      customerName: 'Desy Kristyawati',
      review:
          'Sekali nyoba pengen nyoba lagi habis enak banget '
          'apa lagi sambel nya pedes banget cocok dilidahku.',
    ),
    _CustomerReview(
      customerName: 'Annisa Balqis',
      review:
          'Tempat makannya asik pa lagi harganya murceee '
          'plus bisa request jg mau seberapa level pedesnya 🤗',
    ),
    _CustomerReview(
      customerName: 'Kinsey Alexander',
      review:
          'Rasanya bikin nagih ga nyesel deh dan harga '
          'ga menguras kantong. Pertahankan rasa nya yah.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.publicSurface
          : theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kata Pelanggan',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pengalaman pelanggan yang dibagikan melalui Google Maps.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const _GoogleRatingSummary(),
          const SizedBox(height: AppSpacing.xl),
          AppResponsiveBuilder(
            builder: (context, screenSize, constraints) {
              final columns = switch (screenSize) {
                AppScreenSize.mobile => 1,
                AppScreenSize.tablet => 2,
                AppScreenSize.desktop => 3,
                AppScreenSize.wideDesktop => 3,
              };

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _reviews.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.lg,
                  crossAxisSpacing: AppSpacing.lg,
                  mainAxisExtent: 250,
                ),
                itemBuilder: (context, index) {
                  return _CustomerReviewCard(review: _reviews[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GoogleRatingSummary extends StatelessWidget {
  const _GoogleRatingSummary();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label:
          'Rating Kedai Ayam Nina 5 dari 5 berdasarkan '
          '10 ulasan Google',
      child: AppCard(
        premium: true,
        hoverEnabled: false,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Wrap(
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '5,0',
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    5,
                    (_) => Icon(
                      Icons.star_rounded,
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  '10 ulasan Google',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomerReviewCard extends StatelessWidget {
  const _CustomerReviewCard({required this.review});

  final _CustomerReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      premium: true,
      hoverEnabled: false,
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.format_quote_rounded,
            color: theme.colorScheme.primary,
            size: 30,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Text(
              review.review,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            review.customerName,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Google Maps',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerReview {
  const _CustomerReview({required this.customerName, required this.review});

  final String customerName;
  final String review;
}
