import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/card/cards.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class ContactInformationPanel extends StatelessWidget {
  const ContactInformationPanel({
    super.key,
    required this.phoneNumber,
    required this.location,
    required this.operatingHours,
    required this.onCopyPhone,
    required this.onCopyLocation,
  });

  final String phoneNumber;
  final String location;
  final String operatingHours;
  final VoidCallback onCopyPhone;
  final VoidCallback onCopyLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppSection(
      spacing: AppSectionSpacing.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Kontak',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Hubungi atau kunjungi Kedai Ayam Nina melalui '
            'informasi berikut.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppResponsiveBuilder(
            builder: (context, screenSize, constraints) {
              final columns = switch (screenSize) {
                AppScreenSize.mobile => 1,
                AppScreenSize.tablet => 2,
                AppScreenSize.desktop => 3,
                AppScreenSize.wideDesktop => 3,
              };

              final cards = [
                _ContactInformationCard(
                  icon: Icons.phone_outlined,
                  title: 'Phone',
                  value: phoneNumber,
                  description:
                      'Gunakan nomor berikut untuk menghubungi '
                      'Kedai Ayam Nina.',
                  actionLabel: 'Salin Nomor',
                  onPressed: onCopyPhone,
                ),
                _ContactInformationCard(
                  icon: Icons.location_on_outlined,
                  title: 'Location',
                  value: location,
                  description:
                      'Alamat Kedai Ayam Nina berdasarkan '
                      'informasi Google Maps.',
                  actionLabel: 'Salin Lokasi',
                  onPressed: onCopyLocation,
                ),
                _ContactInformationCard(
                  icon: Icons.schedule_outlined,
                  title: 'Jam Operasional',
                  value: operatingHours,
                  description:
                      'Jam operasional Kedai Ayam Nina '
                      'berlaku setiap hari.',
                ),
              ];

              final totalSpacing = AppSpacing.lg * (columns - 1);

              final itemWidth = (constraints.maxWidth - totalSpacing) / columns;

              return Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: [
                  for (final card in cards)
                    SizedBox(width: itemWidth, child: card),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactInformationCard extends StatelessWidget {
  const _ContactInformationCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.description,
    this.actionLabel,
    this.onPressed,
  });

  final IconData icon;
  final String title;
  final String value;
  final String description;
  final String? actionLabel;
  final VoidCallback? onPressed;

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
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: AppRadius.sm,
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SelectableText(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.55,
            ),
          ),
          if (actionLabel != null && onPressed != null) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              premium: true,
              label: actionLabel!,
              leadingIcon: Icons.content_copy_rounded,
              variant: AppButtonVariant.outlined,
              size: AppButtonSize.small,
              onPressed: onPressed,
            ),
          ],
        ],
      ),
    );
  }
}
