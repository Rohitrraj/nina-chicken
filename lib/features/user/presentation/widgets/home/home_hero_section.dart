import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/buttons/buttons.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';

class HomeHeroSection extends StatelessWidget {
  const HomeHeroSection({super.key, required this.onViewMenu});

  final VoidCallback onViewMenu;

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
              _HeroContent(useDesktopLayout: false, onViewMenu: onViewMenu),
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
  });

  final bool useDesktopLayout;
  final VoidCallback onViewMenu;

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
          Semantics(
            image: true,
            label: 'Logo Kedai Ayam Nina',
            child: Image.asset(
              Assets.logoC1,
              width: 58,
              height: 44,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
              filterQuality: FilterQuality.high,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: 'Kehangatan Kedai dengan '),
                TextSpan(
                  text: 'Ayam Goreng Renyah',
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
                const TextSpan(text: ' yang Sempurna.'),
              ],
            ),
            style: titleStyle,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Nikmati ayam goreng berwarna keemasan, bumbu yang '
            'meresap, dan cita rasa rumahan yang dibuat dari '
            'bahan pilihan.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _HeroActions(
            useDesktopLayout: useDesktopLayout,
            onViewMenu: onViewMenu,
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
  });

  final bool useDesktopLayout;
  final VoidCallback onViewMenu;

  @override
  Widget build(BuildContext context) {
    final button = AppButton(
      premium: true,
      label: 'Lihat Semua Menu',
      variant: AppButtonVariant.primary,
      size: AppButtonSize.large,
      trailingIcon: Icons.arrow_forward_rounded,
      onPressed: onViewMenu,
    );

    if (useDesktopLayout) {
      return Align(alignment: Alignment.centerLeft, child: button);
    }

    return SizedBox(width: double.infinity, child: button);
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

    return Semantics(
      image: true,
      label: 'Sajian ayam Kedai Ayam Nina',
      child: AspectRatio(
        aspectRatio: useDesktopLayout ? 3 / 2 : 4 / 3,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.xl,
            border: Border.all(color: theme.colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.12),
                blurRadius: 34,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.xl,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  Assets.ninaHomeHero,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  excludeFromSemantics: true,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.tertiary.withValues(alpha: 0.10),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
