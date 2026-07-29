import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/features/user/presentation/utils/product_category_label.dart';

void main() {
  group('ProductCategoryLabel', () {
    test('localizes canonical Firestore values', () {
      expect(ProductCategoryLabel.display('food'), 'Makanan');
      expect(ProductCategoryLabel.display('Food'), 'Makanan');
      expect(ProductCategoryLabel.display('beverage'), 'Minuman');
      expect(ProductCategoryLabel.display('Beverage'), 'Minuman');
    });

    test('keeps Indonesian aliases consistent', () {
      expect(ProductCategoryLabel.display('makanan'), 'Makanan');
      expect(ProductCategoryLabel.display('minuman'), 'Minuman');
    });

    test('formats unknown categories without changing stored values', () {
      expect(ProductCategoryLabel.display('  frozen food  '), 'Frozen Food');
      expect(ProductCategoryLabel.display('snack'), 'Snack');
    });

    test('returns safe fallback for empty category', () {
      expect(ProductCategoryLabel.display('   '), 'Tanpa kategori');
    });
  });
}
