import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/cloudinary_image_datasource.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products.dart';

// EVENTS
abstract class ProductCatalogEvent extends Equatable {
  const ProductCatalogEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductCatalogEvent {
  const LoadProducts({this.forceRefresh = false});

  final bool forceRefresh;

  @override
  List<Object?> get props => [forceRefresh];
}

class DeleteProductEvent extends ProductCatalogEvent {
  final Product product;

  const DeleteProductEvent(this.product);

  @override
  List<Object?> get props => <Object?>[product.id, ...product.imagePublicIds];
}

// STATES
abstract class ProductCatalogState extends Equatable {
  const ProductCatalogState();

  @override
  List<Object?> get props => [];
}

class ProductCatalogInitial extends ProductCatalogState {}

class ProductCatalogLoading extends ProductCatalogState {}

class ProductCatalogLoaded extends ProductCatalogState {
  final List<Product> products;

  const ProductCatalogLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductCatalogError extends ProductCatalogState {
  final String message;

  const ProductCatalogError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProductCatalogActionSuccess extends ProductCatalogState {
  final String message;

  const ProductCatalogActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// BLOC
class ProductCatalogBloc
    extends Bloc<ProductCatalogEvent, ProductCatalogState> {
  static const Duration cacheLifetime = Duration(minutes: 5);

  final GetProducts getProducts;
  final DeleteProduct deleteProduct;
  final CloudinaryImageDatasource cloudinaryImageDatasource;

  List<Product>? _cachedProducts;
  DateTime? _lastLoadedAt;

  bool get _hasFreshCache {
    final cachedProducts = _cachedProducts;
    final lastLoadedAt = _lastLoadedAt;

    return cachedProducts != null &&
        lastLoadedAt != null &&
        DateTime.now().difference(lastLoadedAt) < cacheLifetime;
  }

  ProductCatalogBloc({
    required this.getProducts,
    required this.deleteProduct,
    required this.cloudinaryImageDatasource,
  }) : super(ProductCatalogInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductCatalogState> emit,
  ) async {
    if (!event.forceRefresh && _hasFreshCache) {
      final cachedState = ProductCatalogLoaded(_cachedProducts!);

      if (state != cachedState) {
        emit(cachedState);
      }

      return;
    }

    emit(ProductCatalogLoading());

    try {
      final products = List<Product>.unmodifiable(await getProducts());

      _cachedProducts = products;
      _lastLoadedAt = DateTime.now();

      emit(ProductCatalogLoaded(products));
    } catch (error) {
      emit(ProductCatalogError(_readError(error)));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductCatalogState> emit,
  ) async {
    final previousProducts = state is ProductCatalogLoaded
        ? List<Product>.from((state as ProductCatalogLoaded).products)
        : <Product>[];

    final product = event.product;

    try {
      await deleteProduct(product.id);

      final cleanupSucceeded = await _deleteCloudinaryImages(
        product.imagePublicIds,
      );

      final updatedProducts = List<Product>.unmodifiable(
        previousProducts.where((item) => item.id != product.id),
      );

      _cachedProducts = updatedProducts;
      _lastLoadedAt = DateTime.now();

      emit(
        ProductCatalogActionSuccess(
          cleanupSucceeded
              ? 'Product deleted successfully'
              : 'Product deleted, but image cleanup requires review',
        ),
      );

      emit(ProductCatalogLoaded(updatedProducts));
    } catch (error) {
      emit(ProductCatalogError(_readError(error)));

      if (previousProducts.isNotEmpty) {
        emit(ProductCatalogLoaded(previousProducts));
      }
    }
  }

  Future<bool> _deleteCloudinaryImages(Iterable<String> publicIds) async {
    var allDeleted = true;

    final normalizedIds = publicIds
        .map((publicId) => publicId.trim())
        .where((publicId) => publicId.isNotEmpty)
        .toSet();

    for (final publicId in normalizedIds) {
      try {
        await cloudinaryImageDatasource.deleteProductImage(publicId);
      } catch (_) {
        allDeleted = false;
      }
    }

    return allDeleted;
  }

  String _readError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}
