abstract final class ProductCategoryLabel {
  static const Map<String, String> _localizedLabels = {
    'food': 'Makanan',
    'makanan': 'Makanan',
    'beverage': 'Minuman',
    'minuman': 'Minuman',
  };

  static String display(String rawCategory) {
    final category = rawCategory.trim();

    if (category.isEmpty) {
      return 'Tanpa kategori';
    }

    final localized = _localizedLabels[category.toLowerCase()];

    if (localized != null) {
      return localized;
    }

    return category.split(RegExp(r'\s+')).map(_capitalize).join(' ');
  }

  static String _capitalize(String word) {
    if (word.isEmpty) {
      return word;
    }

    return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
  }
}
