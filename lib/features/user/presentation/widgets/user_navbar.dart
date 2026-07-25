import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/core/widgets/layout/layout.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navigation_destination.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class UserNavBar extends StatelessWidget {
  const UserNavBar({super.key, this.isDesktop});

  /// Dipertahankan sementara agar halaman lama tidak langsung rusak.
  ///
  /// Ketika null, ukuran layar dibaca dari AppBreakpoints.
  final bool? isDesktop;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final useDesktopNavigation =
        isDesktop ?? AppBreakpoints.isDesktopWidth(viewportWidth);
    final currentPath = GoRouterState.of(context).uri.path;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      floating: false,
      snap: false,
      toolbarHeight: 76,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: theme.brightness == Brightness.light
          ? AppColors.publicSurface
          : theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Center(
          child: AppContentContainer(
            child: Row(
              children: [
                if (!useDesktopNavigation) ...[
                  Builder(
                    builder: (context) {
                      return IconButton(
                        tooltip: 'Buka navigasi',
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                        icon: const Icon(Icons.menu_rounded),
                      );
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                _BrandButton(
                  onTap: () {
                    if (currentPath != MyRoute.home.path) {
                      context.goNamed(MyRoute.home.name);
                    }
                  },
                ),
                const Spacer(),
                if (useDesktopNavigation)
                  for (final destination in userNavigationDestinations) ...[
                    _DesktopNavigationButton(
                      destination: destination,
                      selected: destination.isActive(currentPath),
                    ),
                    if (destination != userNavigationDestinations.last)
                      const SizedBox(width: AppSpacing.xs),
                  ],
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _BrandButton extends StatelessWidget {
  const _BrandButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: 'Kembali ke halaman utama Kedai Ayam Nina',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.sm,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xxs,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  Assets.logoC1,
                  width: 46,
                  height: 46,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Kedai Ayam Nina',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
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

class _DesktopNavigationButton extends StatelessWidget {
  const _DesktopNavigationButton({
    required this.destination,
    required this.selected,
  });

  final UserNavigationDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary100, AppColors.primary50],
                )
              : null,
          borderRadius: AppRadius.pill,
          border: selected
              ? Border.all(color: AppColors.primary200, width: 1)
              : null,
        ),
        child: TextButton(
          onPressed: () {
            final currentPath = GoRouterState.of(context).uri.path;

            if (!destination.isActive(currentPath)) {
              context.goNamed(destination.route.name);
            }
          },
          style: ButtonStyle(
            animationDuration: const Duration(milliseconds: 180),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (selected) {
                return AppColors.primary800;
              }

              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AppColors.primary700;
              }

              return theme.colorScheme.onSurfaceVariant;
            }),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (selected) {
                return Colors.transparent;
              }

              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return AppColors.primary50.withValues(alpha: 0.90);
              }

              return Colors.transparent;
            }),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: AppRadius.pill),
            ),
            textStyle: WidgetStatePropertyAll(
              theme.textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          child: Text(destination.label),
        ),
      ),
    );
  }
}
