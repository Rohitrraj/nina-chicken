import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';

class CatalogProductFilter {
  const CatalogProductFilter._();

  static const String allCategory = 'Semua';

  static List<String> categories(List<Product> products) {
    final categoriesByKey = <String, String>{};

    for (final product in products) {
      final category = product.category.trim();

      if (category.isEmpty) {
        continue;
      }

      categoriesByKey.putIfAbsent(category.toLowerCase(), () => category);
    }

    final productCategories = categoriesByKey.values.toList()
      ..sort(
        (first, second) => first.toLowerCase().compareTo(second.toLowerCase()),
      );

    return [allCategory, ...productCategories];
  }

  static List<Product> apply({
    required List<Product> products,
    required String query,
    required String category,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    final normalizedCategory = category.trim().toLowerCase();

    final showAllCategories =
        normalizedCategory.isEmpty ||
        normalizedCategory == allCategory.toLowerCase();

    return products.where((product) {
      final categoryMatches =
          showAllCategories ||
          product.category.trim().toLowerCase() == normalizedCategory;

      if (!categoryMatches) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      final searchableContent = [
        product.name,
        product.category,
        product.shortDescription,
        product.description,
      ].join(' ').toLowerCase();

      return searchableContent.contains(normalizedQuery);
    }).toList();
  }
}
