import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/core/design_system/design_system.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';

class AdminShellProvider extends InheritedWidget {
  const AdminShellProvider({
    super.key,
    required this.navigationShell,
    required super.child,
  });

  final StatefulNavigationShell navigationShell;

  static StatefulNavigationShell of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AdminShellProvider>();

    if (provider == null) {
      throw StateError('AdminShellProvider tidak ditemukan dalam context.');
    }

    return provider.navigationShell;
  }

  @override
  bool updateShouldNotify(AdminShellProvider oldWidget) {
    return navigationShell.currentIndex !=
        oldWidget.navigationShell.currentIndex;
  }
}

class MainScaffoldAdmin extends StatelessWidget {
  const MainScaffoldAdmin({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const List<_AdminDestination> _destinations = [
    _AdminDestination(
      branchIndex: 3,
      icon: Icons.analytics_outlined,
      selectedIcon: Icons.analytics_rounded,
      label: 'Analitik',
      description: 'Ringkasan dan pertumbuhan keuangan',
    ),
    _AdminDestination(
      branchIndex: 1,
      icon: Icons.inventory_2_outlined,
      selectedIcon: Icons.inventory_2_rounded,
      label: 'Produk',
      description: 'Kelola katalog menu',
    ),
    _AdminDestination(
      branchIndex: 2,
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      label: 'Buku Kas',
      description: 'Catat pemasukan dan pengeluaran',
    ),
    _AdminDestination(
      branchIndex: 0,
      icon: Icons.history_outlined,
      selectedIcon: Icons.history_rounded,
      label: 'Riwayat',
      description: 'Lihat dan kelola transaksi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = AppBreakpoints.isDesktopWidth(viewportWidth);

    final drawerWidth = viewportWidth < 360 ? viewportWidth * 0.90 : 320.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary700,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 1,
              titleSpacing: AppSpacing.xs,
              title: Text(
                'Kedai Ayam Nina',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary700,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
      drawer: isDesktop
          ? null
          : SizedBox(
              width: drawerWidth,
              child: Drawer(
                backgroundColor: AppColors.surface,
                surfaceTintColor: Colors.transparent,
                child: SafeArea(
                  child: _AdminSidebar(
                    destinations: _destinations,
                    currentIndex: navigationShell.currentIndex,
                    isDrawer: true,
                    onSelected: (index) {
                      _selectBranch(context, index, closeDrawer: true);
                    },
                    onLogout: () {
                      _logout(context, closeDrawer: true);
                    },
                  ),
                ),
              ),
            ),
      body: AdminShellProvider(
        navigationShell: navigationShell,
        child: isDesktop
            ? Row(
                children: [
                  SizedBox(
                    width: 280,
                    child: ColoredBox(
                      color: AppColors.surface,
                      child: SafeArea(
                        child: _AdminSidebar(
                          destinations: _destinations,
                          currentIndex: navigationShell.currentIndex,
                          isDrawer: false,
                          onSelected: (index) {
                            _selectBranch(context, index);
                          },
                          onLogout: () {
                            _logout(context);
                          },
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(
                    width: 1,
                    thickness: 1,
                    color: AppColors.border,
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: AppColors.background,
                      child: navigationShell,
                    ),
                  ),
                ],
              )
            : ColoredBox(color: AppColors.background, child: navigationShell),
      ),
    );
  }

  void _selectBranch(
    BuildContext context,
    int index, {
    bool closeDrawer = false,
  }) {
    if (closeDrawer) {
      Navigator.of(context).pop();
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _logout(BuildContext context, {bool closeDrawer = false}) {
    if (closeDrawer) {
      Navigator.of(context).pop();
    }

    context.read<AuthBloc>().add(AuthLogout());
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({
    required this.destinations,
    required this.currentIndex,
    required this.isDrawer,
    required this.onSelected,
    required this.onLogout,
  });

  final List<_AdminDestination> destinations;
  final int currentIndex;
  final bool isDrawer;
  final ValueChanged<int> onSelected;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AdminIdentity(compact: isDrawer),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                child: Text(
                  'NAVIGASI',
                  style: AppTypography.sectionEyebrow.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final destination in destinations) ...[
                _AdminNavigationItem(
                  destination: destination,
                  selected: currentIndex == destination.branchIndex,
                  onTap: () {
                    onSelected(destination.branchIndex);
                  },
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: _AdminLogoutButton(onTap: onLogout),
        ),
      ],
    );
  }
}

class _AdminIdentity extends StatelessWidget {
  const _AdminIdentity({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        compact ? AppSpacing.lg : AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.neutral0,
              borderRadius: AppRadius.md,
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.sm,
            ),
            child: Image.asset(
              Assets.logoC1,
              fit: BoxFit.contain,
              semanticLabel: 'Logo Kedai Ayam Nina',
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kedai Ayam Nina',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Panel Administrator',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminNavigationItem extends StatefulWidget {
  const _AdminNavigationItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final _AdminDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_AdminNavigationItem> createState() => _AdminNavigationItemState();
}

class _AdminNavigationItemState extends State<_AdminNavigationItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    final backgroundColor = selected
        ? AppColors.primary50
        : _hovered
        ? AppColors.surfaceMuted
        : Colors.transparent;

    final borderColor = selected ? AppColors.primary200 : Colors.transparent;

    final foregroundColor = selected
        ? AppColors.primary700
        : _hovered
        ? AppColors.textPrimary
        : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.destination.label,
      hint: widget.destination.description,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovered = false;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.md,
            focusColor: AppColors.primary50,
            hoverColor: Colors.transparent,
            splashColor: AppColors.primary100,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: AppRadius.md,
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary100
                          : AppColors.surfaceMuted,
                      borderRadius: AppRadius.sm,
                    ),
                    child: Icon(
                      selected
                          ? widget.destination.selectedIcon
                          : widget.destination.icon,
                      size: 21,
                      color: foregroundColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.destination.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: foregroundColor,
                                fontWeight: selected
                                    ? FontWeight.w800
                                    : FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.destination.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textMuted,
                                fontSize: 11,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminLogoutButton extends StatefulWidget {
  const _AdminLogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_AdminLogoutButton> createState() => _AdminLogoutButtonState();
}

class _AdminLogoutButtonState extends State<_AdminLogoutButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Keluar dari dashboard admin',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hovered = false;
          });
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadius.md,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: _hovered ? AppColors.errorSurface : Colors.transparent,
                borderRadius: AppRadius.md,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 21,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Keluar',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminDestination {
  const _AdminDestination({
    required this.branchIndex,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.description,
  });

  final int branchIndex;
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String description;
}
