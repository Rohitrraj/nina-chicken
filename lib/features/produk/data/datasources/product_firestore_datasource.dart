import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';

abstract class ProductFirestoreDatasource {
  Future<List<ProductModel>> getProducts();

  Future<void> createProduct(ProductModel product);

  Future<void> updateProduct(ProductModel product);

  Future<void> deleteProduct(String id);
}

class ProductFirestoreDatasourceImpl implements ProductFirestoreDatasource {
  ProductFirestoreDatasourceImpl({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // One-time read, bukan realtime listener.
      final snapshot = await _products.get();

      final products = snapshot.docs
          .map(
            (document) =>
                ProductModel.fromFirestore(document.id, document.data()),
          )
          .toList(growable: false);

      // Dengan 20–30 produk, sorting lokal lebih ringan dan tidak membutuhkan
      // query/index tambahan pada Firestore.
      products.sort(
        (first, second) =>
            first.name.toLowerCase().compareTo(second.name.toLowerCase()),
      );

      return products;
    } on FirebaseException catch (error) {
      throw Exception(
        'Gagal memuat daftar produk dari Firestore '
        '(${error.code}): ${error.message ?? 'Unknown error'}',
      );
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    try {
      await _products.add(<String, dynamic>{
        ...product.toFirestore(),
        'imagePublicIds': const <String>[],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw Exception(
        'Gagal membuat produk di Firestore '
        '(${error.code}): ${error.message ?? 'Unknown error'}',
      );
    }
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final productId = product.id.trim();

    if (productId.isEmpty) {
      throw ArgumentError('Product ID tidak boleh kosong saat update.');
    }

    try {
      await _products.doc(productId).update(<String, dynamic>{
        ...product.toFirestore(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (error) {
      throw Exception(
        'Gagal memperbarui produk di Firestore '
        '(${error.code}): ${error.message ?? 'Unknown error'}',
      );
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final productId = id.trim();

    if (productId.isEmpty) {
      throw ArgumentError('Product ID tidak boleh kosong saat delete.');
    }

    try {
      await _products.doc(productId).delete();
    } on FirebaseException catch (error) {
      throw Exception(
        'Gagal menghapus produk dari Firestore '
        '(${error.code}): ${error.message ?? 'Unknown error'}',
      );
    }
  }
}
