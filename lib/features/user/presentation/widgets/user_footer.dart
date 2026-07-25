import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class UserFooter extends StatelessWidget {
  const UserFooter({super.key, this.isDesktop});

  /// Dipertahankan agar halaman lama tetap kompatibel.
  ///
  /// Ketika null, kategori layar dibaca dari AppResponsiveBuilder.
  final bool? isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: AppResponsiveBuilder(
        builder: (context, screenSize, constraints) {
          final useDesktopLayout = isDesktop ?? screenSize.isDesktop;

          return AppContentContainer(
            padding: EdgeInsets.symmetric(
              horizontal: AppBreakpoints.horizontalPadding(
                constraints.maxWidth,
              ),
              vertical: useDesktopLayout ? AppSpacing.xl : AppSpacing.lg,
            ),
            child: useDesktopLayout
                ? Row(
                    children: [
                      const Expanded(child: _FooterBrand()),
                      const SizedBox(width: AppSpacing.xl),
                      Text(
                        '© $currentYear Kedai Ayam Nina',
                        textAlign: TextAlign.right,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FooterBrand(),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        '© $currentYear Kedai Ayam Nina',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(Assets.logoC1, width: 46, height: 46, fit: BoxFit.contain),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kedai Ayam Nina',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                'Cita rasa hangat yang dibuat dengan sepenuh hati.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
