import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({
    super.key,
    required this.onViewMenu,
    required this.onContact,
  });

  final VoidCallback onViewMenu;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return AppSection(
      spacing: AppSectionSpacing.spacious,
      child: AppResponsiveBuilder(
        builder: (context, screenSize, constraints) {
          final useDesktopLayout =
              screenSize == AppScreenSize.desktop ||
              screenSize == AppScreenSize.wideDesktop;

          if (useDesktopLayout) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 11,
                  child: _HeroContent(
                    useDesktopLayout: true,
                    onViewMenu: onViewMenu,
                    onContact: onContact,
                  ),
                ),
                const SizedBox(width: AppSpacing.sectionSm),
                const Expanded(
                  flex: 9,
                  child: _HeroVisual(useDesktopLayout: true),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroContent(
                useDesktopLayout: false,
                onViewMenu: onViewMenu,
                onContact: onContact,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _HeroVisual(useDesktopLayout: false),
            ],
          );
        },
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({
    required this.useDesktopLayout,
    required this.onViewMenu,
    required this.onContact,
  });

  final bool useDesktopLayout;
  final VoidCallback onViewMenu;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle =
        (useDesktopLayout
                ? theme.textTheme.displayMedium
                : theme.textTheme.headlineLarge)
            ?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w800,
              height: 1.08,
              letterSpacing: useDesktopLayout ? -1.8 : -1,
            );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 660),
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
              'KEDAI AYAM NINA',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Ayam geprek hangat,\n'),
                TextSpan(
                  text: 'rasa yang selalu dirindukan.',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ],
            ),
            style: titleStyle,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Temukan pilihan menu Kedai Ayam Nina dengan cita rasa '
            'rumahan yang akrab, praktis, dan mudah dinikmati.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _HeroActions(
            useDesktopLayout: useDesktopLayout,
            onViewMenu: onViewMenu,
            onContact: onContact,
          ),
          const SizedBox(height: AppSpacing.xl),
          const Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            children: [
              _HeroTrustItem(
                icon: Icons.restaurant_menu_rounded,
                label: 'Pilihan menu jelas',
              ),
              _HeroTrustItem(
                icon: Icons.devices_rounded,
                label: 'Mudah diakses',
              ),
              _HeroTrustItem(
                icon: Icons.favorite_outline_rounded,
                label: 'Cita rasa rumahan',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroActions extends StatelessWidget {
  const _HeroActions({
    required this.useDesktopLayout,
    required this.onViewMenu,
    required this.onContact,
  });

  final bool useDesktopLayout;
  final VoidCallback onViewMenu;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    if (useDesktopLayout) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          AppButton(
            label: 'Lihat Menu',
            variant: AppButtonVariant.primary,
            size: AppButtonSize.large,
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: onViewMenu,
          ),
          AppButton(
            label: 'Hubungi Kami',
            variant: AppButtonVariant.outlined,
            size: AppButtonSize.large,
            onPressed: onContact,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Lihat Menu',
            variant: AppButtonVariant.primary,
            size: AppButtonSize.large,
            trailingIcon: Icons.arrow_forward_rounded,
            onPressed: onViewMenu,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: AppButton(
            label: 'Hubungi Kami',
            variant: AppButtonVariant.outlined,
            size: AppButtonSize.large,
            onPressed: onContact,
          ),
        ),
      ],
    );
  }
}

class _HeroTrustItem extends StatelessWidget {
  const _HeroTrustItem({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroVisual extends StatelessWidget {
  const _HeroVisual({required this.useDesktopLayout});

  final bool useDesktopLayout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: useDesktopLayout ? 1.02 : 1.12,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
          ),
          borderRadius: AppRadius.xl,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -70,
              right: -50,
              child: _DecorativeCircle(
                size: 190,
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
              ),
            ),
            Positioned(
              left: -55,
              bottom: -65,
              child: _DecorativeCircle(
                size: 170,
                color: theme.colorScheme.secondary.withValues(alpha: 0.15),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.all(
                  useDesktopLayout ? AppSpacing.sectionSm : AppSpacing.xxl,
                ),
                child: Center(
                  child: Image.asset(
                    Assets.logoC1,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                    semanticLabel: 'Logo Kedai Ayam Nina',
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: _HeroBadge(
                icon: Icons.local_fire_department_outlined,
                label: 'Ayam geprek',
              ),
            ),
            Positioned(
              top: AppSpacing.lg,
              right: AppSpacing.lg,
              child: _HeroBadge(
                icon: Icons.storefront_outlined,
                label: 'Kedai lokal',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: AppRadius.pill,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
