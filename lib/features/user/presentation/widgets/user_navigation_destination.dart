import 'package:flutter/material.dart';
import 'package:kedai_ayam_nina/router/router.dart';

/// Satu sumber data untuk navbar desktop dan drawer mobile.
class UserNavigationDestination {
  const UserNavigationDestination({
    required this.label,
    required this.icon,
    required this.route,
    this.additionalActivePaths = const <String>{},
  });

  final String label;
  final IconData icon;
  final MyRoute route;

  /// Route tambahan yang harus mengaktifkan menu ini.
  ///
  /// Contoh: halaman detail produk tetap membuat menu "Menu" terlihat aktif.
  final Set<String> additionalActivePaths;

  bool isActive(String currentPath) {
    if (_matchesPath(currentPath, route.path)) {
      return true;
    }

    return additionalActivePaths.any((path) => _matchesPath(currentPath, path));
  }

  bool _matchesPath(String currentPath, String destinationPath) {
    return currentPath == destinationPath ||
        currentPath.startsWith('$destinationPath/');
  }
}

const userNavigationDestinations = <UserNavigationDestination>[
  UserNavigationDestination(
    label: 'Home',
    icon: Icons.home_outlined,
    route: MyRoute.home,
  ),
  UserNavigationDestination(
    label: 'Menu',
    icon: Icons.restaurant_menu_outlined,
    route: MyRoute.catalog,
    additionalActivePaths: {'/detail'},
  ),
  UserNavigationDestination(
    label: 'About',
    icon: Icons.info_outline_rounded,
    route: MyRoute.about,
  ),
  UserNavigationDestination(
    label: 'Contact Us',
    icon: Icons.contact_mail_outlined,
    route: MyRoute.contactUs,
  ),
];
