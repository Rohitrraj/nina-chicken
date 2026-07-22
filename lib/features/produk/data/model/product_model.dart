import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    @JsonKey(name: 'type') required super.category,
    @JsonKey(name: 'longDescription') required super.description,
    required super.shortDescription,
    required super.price,
    @JsonKey(name: 'imageUrls') required super.imageUrl,
    @JsonKey(name: 'imagePublicIds', defaultValue: <String>[])
    super.imagePublicIds = const <String>[],
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  factory ProductModel.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    return ProductModel(
      id: documentId,
      name: _parseString(data['name']),
      category: _parseString(data['category'] ?? data['type']),
      description: _parseString(data['description'] ?? data['longDescription']),
      shortDescription: _parseString(data['shortDescription']),
      price: _parsePrice(data['price']),
      imageUrl: _parseStringList(data['imageUrls']),
      imagePublicIds: _parseStringList(data['imagePublicIds']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name.trim(),
      'category': category.trim(),
      'description': description.trim(),
      'shortDescription': shortDescription.trim(),
      'price': price,
      'imageUrls': List<String>.from(imageUrl),
      'imagePublicIds': List<String>.from(imagePublicIds),
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      category: product.category,
      description: product.description,
      shortDescription: product.shortDescription,
      price: product.price,
      imageUrl: product.imageUrl,
      imagePublicIds: product.imagePublicIds,
    );
  }

  static String _parseString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static double _parsePrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value is List) {
      return value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(growable: false);
    }

    if (value is String && value.trim().isNotEmpty) {
      return <String>[value.trim()];
    }

    return const <String>[];
  }
}
