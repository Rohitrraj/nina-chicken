import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kedai_ayam_nina/core/assets.dart';
import 'package:kedai_ayam_nina/router/router.dart';

class UserNavBar extends StatelessWidget {
  final bool isDesktop;

  const UserNavBar({super.key, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;

    Color getColor(String path) {
      return currentPath == path ? const Color(0xFF8B4513) : Colors.black87;
    }

    FontWeight getWeight(String path) {
      return currentPath == path ? FontWeight.bold : FontWeight.normal;
    }

    return SliverAppBar(
      iconTheme: const IconThemeData(
        color: Color(
          0xFF6B240C,
        ), // Contoh warna cokelat menyesuaikan teks, atau gunakan Colors.black
      ),
      backgroundColor: const Color(0xFFFDFBF0),
      floating: true,
      pinned: true,
      elevation: 0,
      title: InkWell(
        onTap: () {
          context.goNamed(MyRoute.home.name);
        },
        child: Row(
          children: [
            Image.asset(Assets.logoC1, width: 64, height: 64),
            const Text(
              "Kedai Ayam Nina",
              style: TextStyle(
                color: Color(0xFF8B4513),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (isDesktop) ...[
          TextButton(
            onPressed: () {
              context.goNamed(MyRoute.home.name);
            },
            child: Text(
              "Home",
              style: TextStyle(
                color: getColor(MyRoute.home.path),
                fontWeight: getWeight(MyRoute.home.path),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              context.goNamed(MyRoute.catalog.name);
            },
            child: Text(
              "Menu",
              style: TextStyle(
                color: getColor(MyRoute.catalog.path),
                fontWeight: getWeight(MyRoute.catalog.path),
              ),
            ),
          ),

          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              context.goNamed(MyRoute.about.name);
            },
            child: Text(
              "About",
              style: TextStyle(
                color: getColor(MyRoute.about.path),
                fontWeight: getWeight(MyRoute.about.path),
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () {
              context.goNamed(MyRoute.contactUs.name);
            },
            child: Text(
              "Contact Us",
              style: TextStyle(
                color: getColor(MyRoute.contactUs.path),
                fontWeight: getWeight(MyRoute.contactUs.path),
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ],
    );
  }
}
