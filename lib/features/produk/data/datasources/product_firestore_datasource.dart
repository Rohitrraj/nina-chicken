import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';

abstract class ProductFirestoreDatasource {
  Future<List<ProductModel>> getProducts();

  Future<void> createProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}

class ProductFirestoreDatasourceImpl implements ProductFirestoreDatasource {
  final CollectionReference<Map<String, dynamic>> _products;

  ProductFirestoreDatasourceImpl({required FirebaseFirestore firestore})
    : _products = firestore.collection('products');

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final snapshot = await _products.get();

      return snapshot.docs
          .map(
            (document) =>
                ProductModel.fromFirestore(document.id, document.data()),
          )
          .toList(growable: false);
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? 'Gagal mengambil data produk.');
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      final document = _products.doc();

      await document.set({
        ...product.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? 'Gagal membuat produk.');
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final productId = product.id.trim();

    if (productId.isEmpty) {
      throw ArgumentError('ID produk tidak boleh kosong.');
    }

    try {
      await _products.doc(productId).update({
        ...product.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? 'Gagal memperbarui produk.');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final productId = id.trim();

    if (productId.isEmpty) {
      throw ArgumentError('ID produk tidak boleh kosong.');
    }

    try {
      await _products.doc(productId).delete();
    } on FirebaseException catch (error) {
      throw Exception(error.message ?? 'Gagal menghapus produk.');
    }
  }
}
