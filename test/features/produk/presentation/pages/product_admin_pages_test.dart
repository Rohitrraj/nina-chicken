import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kedai_ayam_nina/core/theme.dart';
import 'package:kedai_ayam_nina/features/produk/data/datasources/cloudinary_image_datasource.dart';
import 'package:kedai_ayam_nina/features/produk/data/model/cloudinary_upload_result.dart';
import 'package:kedai_ayam_nina/features/produk/domain/entities/product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/repositories/product_repository.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/create_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/delete_product.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/get_products.dart';
import 'package:kedai_ayam_nina/features/produk/domain/usecases/update_product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_catalog_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/bloc/product_mutation_bloc.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/detail_product.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/product_catalog_page.dart';
import 'package:kedai_ayam_nina/features/produk/presentation/pages/product_mutation_page.dart';

class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository({this.products = const <Product>[], this.loadError});

  final List<Product> products;
  final Object? loadError;

  @override
  Future<List<Product>> getProducts() async {
    if (loadError != null) {
      throw loadError!;
    }

    return List<Product>.unmodifiable(products);
  }

  @override
  Future<void> createProduct(Product product) async {}

  @override
  Future<void> updateProduct(Product product) async {}

  @override
  Future<void> deleteProduct(String id) async {}
}

class _FakeCloudinaryImageDatasource implements CloudinaryImageDatasource {
  @override
  Future<CloudinaryUploadResult> uploadProductImage(XFile image) {
    throw UnsupportedError(
      'Upload Cloudinary tidak boleh dipanggil '
      'dalam widget test.',
    );
  }

  @override
  Future<void> deleteProductImage(String publicId) async {}
}

Product _product({
  required String id,
  required String name,
  double price = 25000,
}) {
  return Product(
    id: id,
    name: name,
    category: 'food',
    shortDescription: 'Ayam renyah dengan sambal segar dan rasa gurih.',
    description:
        'Produk ayam dengan bumbu pilihan, sambal segar, '
        'dan penyajian khas Kedai Ayam Nina.',
    price: price,
    imageUrl: const <String>[],
    imagePublicIds: const <String>[],
  );
}

ProductCatalogBloc _createCatalogBloc(ProductRepository repository) {
  return ProductCatalogBloc(
    getProducts: GetProducts(repository),
    deleteProduct: DeleteProduct(repository),
    cloudinaryImageDatasource: _FakeCloudinaryImageDatasource(),
  );
}

ProductMutationBloc _createMutationBloc(ProductRepository repository) {
  return ProductMutationBloc(
    createProduct: CreateProduct(repository),
    updateProduct: UpdateProduct(repository),
    cloudinaryImageDatasource: _FakeCloudinaryImageDatasource(),
  );
}

void _setViewport(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;

  addTearDown(tester.view.resetPhysicalSize);

  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpPage(
  WidgetTester tester, {
  required Widget page,
  required Size size,
}) async {
  _setViewport(tester, size);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      home: page,
    ),
  );

  await tester.pump();
  await tester.pumpAndSettle();
}

void main() {
  final products = <Product>[
    _product(id: 'ayam-penyet', name: 'Ayam Penyet Istimewa'),
    _product(
      id: 'ayam-geprek',
      name: 'Ayam Geprek Sambal Bawang',
      price: 23000,
    ),
  ];

  testWidgets('katalog menampilkan produk pada mobile '
      'tanpa rendering overflow', (tester) async {
    final repository = _FakeProductRepository(products: products);

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    await _pumpPage(
      tester,
      page: ProductCatalogPage(catalogBloc: bloc),
      size: const Size(390, 844),
    );

    expect(find.text('Katalog Produk'), findsOneWidget);

    expect(find.text('Ayam Penyet Istimewa'), findsOneWidget);

    expect(find.textContaining('25.000'), findsOneWidget);

    expect(find.byKey(const Key('admin-product-grid')), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('pencarian katalog memfilter produk', (tester) async {
    final repository = _FakeProductRepository(products: products);

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    await _pumpPage(
      tester,
      page: ProductCatalogPage(catalogBloc: bloc),
      size: const Size(1440, 900),
    );

    await tester.enterText(
      find.byKey(const Key('admin-product-search-field')),
      'geprek',
    );

    await tester.pump();

    expect(find.text('Ayam Geprek Sambal Bawang'), findsOneWidget);

    expect(find.text('Ayam Penyet Istimewa'), findsNothing);

    expect(find.text('1 dari 2 produk'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('katalog menampilkan empty state', (tester) async {
    final repository = _FakeProductRepository();

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    await _pumpPage(
      tester,
      page: ProductCatalogPage(catalogBloc: bloc),
      size: const Size(390, 844),
    );

    expect(find.text('Belum ada produk'), findsOneWidget);

    expect(find.text('Tambah Produk'), findsWidgets);

    expect(tester.takeException(), isNull);
  });

  testWidgets('katalog menampilkan error state aman '
      'tanpa error internal', (tester) async {
    final repository = _FakeProductRepository(
      loadError: Exception('permission-denied: internal firestore detail'),
    );

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    await _pumpPage(
      tester,
      page: ProductCatalogPage(catalogBloc: bloc),
      size: const Size(390, 844),
    );

    expect(find.text('Katalog belum dapat dimuat'), findsOneWidget);

    expect(find.textContaining('permission-denied'), findsNothing);

    expect(find.textContaining('firestore'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('form produk memvalidasi seluruh field wajib '
      'pada mobile', (tester) async {
    final repository = _FakeProductRepository();

    final bloc = _createMutationBloc(repository);

    await _pumpPage(
      tester,
      page: ProductMutationPage(mutationBloc: bloc),
      size: const Size(390, 844),
    );

    final submitButton = find.byKey(const Key('product-submit-button'));

    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Nama produk wajib diisi.'), findsOneWidget);

    expect(find.text('Kategori produk wajib dipilih.'), findsOneWidget);

    expect(find.text('Harga produk wajib diisi.'), findsOneWidget);

    expect(find.text('Deskripsi singkat wajib diisi.'), findsOneWidget);

    expect(find.text('Deskripsi lengkap wajib diisi.'), findsOneWidget);

    expect(find.text('Gambar produk wajib dipilih.'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('detail produk responsif dan dialog hapus aman', (tester) async {
    final repository = _FakeProductRepository(products: products);

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    final product = products.last;

    await _pumpPage(
      tester,
      page: DetailProductPage(product: product, catalogBloc: bloc),
      size: const Size(390, 844),
    );

    expect(find.text('Ayam Geprek Sambal Bawang'), findsWidgets);

    expect(find.text('Makanan'), findsWidgets);

    expect(find.textContaining('23.000'), findsOneWidget);

    final deleteButton = find.byKey(const Key('product-detail-delete-button'));

    await tester.scrollUntilVisible(deleteButton, 250);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Hapus produk?'), findsOneWidget);

    expect(find.textContaining('Ayam Geprek Sambal Bawang'), findsWidgets);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Batal'));

    await tester.pumpAndSettle();

    expect(find.text('Hapus produk?'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('kontrol katalog memiliki semantics '
      'dan target sentuh minimal', (tester) async {
    final semantics = tester.ensureSemantics();

    final repository = _FakeProductRepository(products: products);

    final bloc = _createCatalogBloc(repository);

    addTearDown(() async {
      await bloc.close();
    });

    try {
      await _pumpPage(
        tester,
        page: ProductCatalogPage(catalogBloc: bloc),
        size: const Size(390, 844),
      );

      final addButton = find.byKey(const Key('admin-product-add-button'));

      final refreshButton = find.byKey(
        const Key('admin-product-refresh-button'),
      );

      final addSemantics = tester.getSemantics(addButton);

      expect(addSemantics.label, contains('Tambah Produk'));

      final addSize = tester.getSize(addButton);

      final refreshSize = tester.getSize(refreshButton);

      expect(addSize.height, greaterThanOrEqualTo(48));

      expect(refreshSize.width, greaterThanOrEqualTo(48));

      expect(refreshSize.height, greaterThanOrEqualTo(48));

      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}
