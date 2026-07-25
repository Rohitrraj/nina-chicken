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
      floating: true,
      snap: false,
      toolbarHeight: 76,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: theme.colorScheme.surface,
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
      child: TextButton(
        onPressed: () {
          final currentPath = GoRouterState.of(context).uri.path;

          if (!destination.isActive(currentPath)) {
            context.goNamed(destination.route.name);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: selected
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
          backgroundColor: selected
              ? theme.colorScheme.primaryContainer
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.sm),
          textStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        child: Text(destination.label),
      ),
    );
  }
}
