import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/features/auth/presentations/bloc/auth_bloc.dart';

class AdminShellProvider extends InheritedWidget {
  final StatefulNavigationShell navigationShell;

  const AdminShellProvider({
    super.key,
    required this.navigationShell,
    required super.child,
  });

  static StatefulNavigationShell of(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<AdminShellProvider>();
    if (provider == null) {
      throw Exception('AdminShellProvider not found in context');
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
  final StatefulNavigationShell navigationShell;

  const MainScaffoldAdmin({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF0),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: const Color(0xFFF2EFE5),
              elevation: 0,
              iconTheme: const IconThemeData(color: Color(0xFF8B4513)),
              title: const Text(
                "Nina's Kitchen",
                style: TextStyle(
                  color: Color(0xFF8B4513),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      drawer: isDesktop
          ? null
          : Drawer(
              child: Container(
                color: const Color(0xFFF2EFE5),
                child: _buildSidebarContent(context, true),
              ),
            ),
      body: AdminShellProvider(
        navigationShell: navigationShell,
        child: isDesktop
            ? Row(
                children: [
                  Container(
                    width: 260,
                    color: const Color(0xFFF2EFE5),
                    child: _buildSidebarContent(context, false),
                  ),
                  Expanded(child: navigationShell),
                ],
              )
            : navigationShell,
      ),
    );
  }

  Widget _buildSidebarContent(BuildContext context, bool isFromDrawer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nina's Kitchen",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
              Text(
                "Admin Terminal",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        _SidebarItem(
          icon: Icons.analytics,
          label: "Kitchen Analytics",
          isSelected: navigationShell.currentIndex == 3,
          onTap: () => _handleItemTap(3, context, isFromDrawer),
        ),
        _SidebarItem(
          icon: Icons.restaurant_menu,
          label: "Product Catalog",
          isSelected: navigationShell.currentIndex == 1,
          onTap: () => _handleItemTap(1, context, isFromDrawer),
        ),
        _SidebarItem(
          icon: Icons.receipt_long,
          label: "Buku Kas",
          isSelected: navigationShell.currentIndex == 2,
          onTap: () => _handleItemTap(2, context, isFromDrawer),
        ),
        _SidebarItem(
          icon: Icons.dashboard,
          label: "History",
          isSelected: navigationShell.currentIndex == 0,
          onTap: () => _handleItemTap(0, context, isFromDrawer),
        ),
        const Spacer(),
        const Divider(),
        _SidebarItem(
          icon: Icons.logout,
          label: "Logout",
          isSelected: false,
          onTap: () {
            context.read<AuthBloc>().add(AuthLogout());
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _handleItemTap(int index, BuildContext context, bool isFromDrawer) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    if (isFromDrawer) {
      Navigator.of(context).pop();
    }
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna cokelat primary dari tema kamu
    const primaryColor = Color(0xFF8B4513);

    // Logika warna background (Animasi Hover)
    final bgColor = widget.isSelected
        ? primaryColor.withOpacity(0.15) // Warna saat menu aktif
        : isHovered
        ? primaryColor.withOpacity(0.05) // Warna samar saat di-hover
        : Colors.transparent; // Transparan saat diam

    // Logika warna ikon & teks
    final contentColor = widget.isSelected
        ? primaryColor
        : isHovered
        ? primaryColor.withOpacity(0.8)
        : Colors.grey.shade700;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      // MouseRegion untuk mendeteksi kursor (sangat penting untuk Web/Desktop)
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        // Material & InkWell untuk animasi klik (Ripple effect)
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.onTap.call();
            },
            borderRadius: BorderRadius.circular(12),
            splashColor: primaryColor.withOpacity(
              0.2,
            ), // Warna cipratan saat diklik
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              // Durasi animasi background saat di-hover
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: contentColor, size: 22),
                  const SizedBox(width: 16),
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: contentColor,
                      fontSize: 14,
                      // Font lebih tebal sedikit kalau sedang dipilih
                      fontWeight: widget.isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
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
