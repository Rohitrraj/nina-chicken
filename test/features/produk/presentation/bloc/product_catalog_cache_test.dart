import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/features/produk/data/datasources/cloudinary_image_datasource.dart';
import 'package:kedai_ayam_nina/features/produk/data/model/cloudinary_upload_result.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/repositories/product_repository.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/delete_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/get_products.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';

class _CountingProductRepository implements ProductRepository {
  int getProductsCalls = 0;
  int deleteProductCalls = 0;

  final List<Product> products = <Product>[
    const Product(
      id: 'product-1',
      name: 'Ayam Nina',
      category: 'food',
      description: 'Deskripsi lengkap produk.',
      shortDescription: 'Deskripsi singkat.',
      price: 25000,
      imageUrl: <String>[
        'https://res.cloudinary.com/demo/image/upload/menu.jpg',
      ],
      imagePublicIds: <String>['menu'],
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    getProductsCalls++;

    return List<Product>.unmodifiable(products);
  }

  @override
  Future<void> createProduct(Product product) async {}

  @override
  Future<void> updateProduct(Product product) async {}

  @override
  Future<void> deleteProduct(String id) async {
    deleteProductCalls++;
    products.removeWhere((product) => product.id == id);
  }
}

class _NoopCloudinaryImageDatasource implements CloudinaryImageDatasource {
  @override
  Future<CloudinaryUploadResult> uploadProductImage(XFile image) {
    throw UnsupportedError('Upload tidak digunakan dalam test cache.');
  }

  @override
  Future<void> deleteProductImage(String publicId) async {}
}

ProductCatalogBloc _createBloc(_CountingProductRepository repository) {
  return ProductCatalogBloc(
    getProducts: GetProducts(repository),
    deleteProduct: DeleteProduct(repository),
    cloudinaryImageDatasource: _NoopCloudinaryImageDatasource(),
  );
}

Future<ProductCatalogLoaded> _waitForLoaded(ProductCatalogBloc bloc) async {
  return await bloc.stream.firstWhere((state) => state is ProductCatalogLoaded)
      as ProductCatalogLoaded;
}

void main() {
  test('load pasif memakai cache dan force refresh membaca ulang', () async {
    final repository = _CountingProductRepository();
    final bloc = _createBloc(repository);

    addTearDown(bloc.close);

    final firstLoaded = _waitForLoaded(bloc);
    bloc.add(const LoadProducts());
    await firstLoaded;

    expect(repository.getProductsCalls, 1);

    bloc.add(const LoadProducts());

    await Future<void>.delayed(const Duration(milliseconds: 30));

    expect(
      repository.getProductsCalls,
      1,
      reason:
          'Load pasif dalam masa cache tidak boleh membaca '
          'collection Firestore kembali.',
    );

    final refreshed = _waitForLoaded(bloc);

    bloc.add(const LoadProducts(forceRefresh: true));

    await refreshed;

    expect(repository.getProductsCalls, 2);
  });

  test('delete memperbarui state lokal tanpa read collection baru', () async {
    final repository = _CountingProductRepository();
    final bloc = _createBloc(repository);

    addTearDown(bloc.close);

    final initialLoaded = _waitForLoaded(bloc);
    bloc.add(const LoadProducts());
    final loaded = await initialLoaded;

    final deletedState = _waitForLoaded(bloc);

    bloc.add(DeleteProductEvent(loaded.products.single));

    final afterDelete = await deletedState;

    expect(repository.deleteProductCalls, 1);
    expect(repository.getProductsCalls, 1);
    expect(afterDelete.products, isEmpty);
  });
}
