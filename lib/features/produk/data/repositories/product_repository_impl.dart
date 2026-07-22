import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_firestore_datasource.dart';
import '../model/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductFirestoreDatasource firestoreDatasource;

  ProductRepositoryImpl({required this.firestoreDatasource});

  @override
  Future<List<Product>> getProducts() async {
    return firestoreDatasource.getProducts();
  }

  @override
  Future<void> createProduct(Product product) async {
    await firestoreDatasource.createProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(Product product) async {
    await firestoreDatasource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await firestoreDatasource.deleteProduct(id);
  }
}
