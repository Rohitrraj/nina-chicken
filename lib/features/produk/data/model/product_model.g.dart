// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['type'] as String,
  description: json['longDescription'] as String,
  shortDescription: json['shortDescription'] as String,
  price: (json['price'] as num).toDouble(),
  imageUrl: (json['imageUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  imagePublicIds:
      (json['imagePublicIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.category,
      'longDescription': instance.description,
      'shortDescription': instance.shortDescription,
      'price': instance.price,
      'imageUrls': instance.imageUrl,
      'imagePublicIds': instance.imagePublicIds,
    };
