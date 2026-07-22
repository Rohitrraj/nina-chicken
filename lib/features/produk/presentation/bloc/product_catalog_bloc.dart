import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/delete_product.dart';

// EVENTS
abstract class ProductCatalogEvent extends Equatable {
  const ProductCatalogEvent();
  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductCatalogEvent {}

class DeleteProductEvent extends ProductCatalogEvent {
  final String productId;
  const DeleteProductEvent(this.productId);
  @override
  List<Object?> get props => [productId];
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
  final GetProducts getProducts;
  final DeleteProduct deleteProduct;

  ProductCatalogBloc({required this.getProducts, required this.deleteProduct})
    : super(ProductCatalogInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<DeleteProductEvent>(_onDeleteProduct);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductCatalogState> emit,
  ) async {
    emit(ProductCatalogLoading());
    try {
      final products = await getProducts();
      emit(ProductCatalogLoaded(products));
    } catch (e) {
      emit(ProductCatalogError(e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductEvent event,
    Emitter<ProductCatalogState> emit,
  ) async {
    final previousProducts = state is ProductCatalogLoaded
        ? List<Product>.from((state as ProductCatalogLoaded).products)
        : <Product>[];

    try {
      await deleteProduct(event.productId);

      final updatedProducts = previousProducts
          .where((product) => product.id != event.productId)
          .toList(growable: false);

      emit(const ProductCatalogActionSuccess('Product deleted successfully'));

      // Perbarui state lokal tanpa membaca ulang seluruh collection.
      emit(ProductCatalogLoaded(updatedProducts));
    } catch (error) {
      emit(ProductCatalogError(error.toString()));

      // Pertahankan katalog sebelumnya ketika delete gagal.
      if (previousProducts.isNotEmpty) {
        emit(ProductCatalogLoaded(previousProducts));
      }
    }
  }
}
