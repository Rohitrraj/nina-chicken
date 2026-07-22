class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final String shortDescription;
  final double price;
  final List<String> imageUrl;
  final List<String> imagePublicIds;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.imageUrl,
    this.imagePublicIds = const <String>[],
  });
}
