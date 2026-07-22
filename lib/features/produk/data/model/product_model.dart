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
  });

  /// Mapper untuk API lama.
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  /// Mapper untuk API lama.
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Mapper khusus dokumen Cloud Firestore.
  ///
  /// Document ID Firestore digunakan sebagai Product.id sehingga field `id`
  /// tidak perlu disimpan ulang di dalam dokumen.
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
      imageUrl: _parseImageUrls(data['imageUrls']),
    );
  }

  /// Data inti yang disimpan di Cloud Firestore.
  ///
  /// createdAt dan updatedAt ditambahkan oleh datasource menggunakan
  /// FieldValue.serverTimestamp().
  Map<String, dynamic> toFirestore() {
    return <String, dynamic>{
      'name': name.trim(),
      'category': category.trim(),
      'description': description.trim(),
      'shortDescription': shortDescription.trim(),
      'price': price,
      'imageUrls': List<String>.from(imageUrl),
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
    );
  }

  static String _parseString(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
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

  static List<String> _parseImageUrls(dynamic value) {
    if (value is List) {
      return value
          .whereType<String>()
          .map((url) => url.trim())
          .where((url) => url.isNotEmpty)
          .toList(growable: false);
    }

    // Fallback untuk data lama yang mungkin menyimpan satu URL sebagai string.
    if (value is String && value.trim().isNotEmpty) {
      return <String>[value.trim()];
    }

    return const <String>[];
  }
}
