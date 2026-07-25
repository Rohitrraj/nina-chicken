import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/user_navigation_destination.dart';

void main() {
  group('UserNavigationDestination.isActive', () {
    test('marks exact route as active', () {
      final home = userNavigationDestinations.first;

      expect(home.isActive('/home'), isTrue);
      expect(home.isActive('/catalog'), isFalse);
    });

    test('marks nested route as active', () {
      final catalog = userNavigationDestinations[1];

      expect(catalog.isActive('/catalog/category/food'), isTrue);
    });

    test('marks product detail route as Menu', () {
      final catalog = userNavigationDestinations[1];

      expect(catalog.isActive('/detail'), isTrue);
    });

    test('does not activate unrelated destination', () {
      final about = userNavigationDestinations[2];

      expect(about.isActive('/contact_us'), isFalse);
    });
  });

  test('uses Indonesian public navigation labels', () {
    expect(
      userNavigationDestinations
          .map((destination) => destination.label)
          .toList(),
      ['Beranda', 'Menu', 'Tentang', 'Kontak'],
    );
  });
}
