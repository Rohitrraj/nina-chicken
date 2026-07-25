import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/user/presentation/widgets/catalog/catalog.dart';

void main() {
  const products = [
    Product(
      id: '1',
      name: 'Ayam Penyet',
      category: 'Food',
      description: 'Ayam dengan sambal pedas.',
      shortDescription: 'Ayam penyet.',
      price: 25000,
      imageUrl: [],
    ),
    Product(
      id: '2',
      name: 'Es Teh',
      category: 'Beverage',
      description: 'Minuman teh dingin.',
      shortDescription: 'Es teh segar.',
      price: 5000,
      imageUrl: [],
    ),
    Product(
      id: '3',
      name: 'Ayam Geprek',
      category: 'food',
      description: 'Ayam geprek rumahan.',
      shortDescription: 'Geprek sambal.',
      price: 18000,
      imageUrl: [],
    ),
  ];

  test('categories removes case-insensitive duplicates', () {
    final categories = CatalogProductFilter.categories(products);

    expect(categories, [CatalogProductFilter.allCategory, 'Beverage', 'Food']);
  });

  test('apply filters products by category', () {
    final result = CatalogProductFilter.apply(
      products: products,
      query: '',
      category: 'Food',
    );

    expect(result.length, 2);
    expect(result.map((product) => product.id), containsAll(['1', '3']));
  });

  test('apply searches across product fields', () {
    final result = CatalogProductFilter.apply(
      products: products,
      query: 'pedas',
      category: CatalogProductFilter.allCategory,
    );

    expect(result.length, 1);
    expect(result.single.id, '1');
  });

  test('apply combines search and category', () {
    final result = CatalogProductFilter.apply(
      products: products,
      query: 'geprek',
      category: 'Food',
    );

    expect(result.length, 1);
    expect(result.single.id, '3');
  });
}
