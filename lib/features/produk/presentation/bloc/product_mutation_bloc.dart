import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/datasources/cloudinary_image_datasource.dart';
import '../../data/model/cloudinary_upload_result.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/update_product.dart';
import '../models/product_mutation_input.dart';

part 'product_mutation_event.dart';
part 'product_mutation_state.dart';

class ProductMutationBloc
    extends Bloc<ProductMutationEvent, ProductMutationState> {
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final CloudinaryImageDatasource cloudinaryImageDatasource;

  ProductMutationBloc({
    required this.createProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.cloudinaryImageDatasource,
  }) : super(ProductMutationInitial()) {
    on<DoCreateProduct>(_onCreateProduct);
    on<DoUpdateProduct>(_onUpdateProduct);
    on<DoDeleteProduct>(_onDeleteProduct);
  }

  Future<void> _onCreateProduct(
    DoCreateProduct event,
    Emitter<ProductMutationState> emit,
  ) async {
    emit(ProductMutationLoading());

    _PreparedProduct? preparedProduct;

    try {
      preparedProduct = await _prepareProduct(event.input);

      await createProduct(preparedProduct.product);

      emit(ProductMutationSuccess('Product Successfully Created!'));
    } catch (error) {
      await _rollbackUpload(preparedProduct?.uploadResult);

      emit(ProductMutationFailure(_readError(error)));
    }
  }

  Future<void> _onUpdateProduct(
    DoUpdateProduct event,
    Emitter<ProductMutationState> emit,
  ) async {
    emit(ProductMutationLoading());

    _PreparedProduct? preparedProduct;

    try {
      preparedProduct = await _prepareProduct(event.input);

      await updateProduct(preparedProduct.product);

      emit(ProductMutationSuccess('Product Successfully Updated!'));
    } catch (error) {
      await _rollbackUpload(preparedProduct?.uploadResult);

      emit(ProductMutationFailure(_readError(error)));
    }
  }

  Future<void> _onDeleteProduct(
    DoDeleteProduct event,
    Emitter<ProductMutationState> emit,
  ) async {
    emit(ProductMutationLoading());

    try {
      await deleteProduct(event.id);

      emit(ProductMutationSuccess('Product Successfully Deleted!'));
    } catch (error) {
      emit(ProductMutationFailure(_readError(error)));
    }
  }

  Future<_PreparedProduct> _prepareProduct(ProductMutationInput input) async {
    final selectedImage = input.selectedImage;

    if (selectedImage == null) {
      if (input.product.imageUrl.isEmpty) {
        throw Exception('Gambar produk tidak boleh kosong.');
      }

      return _PreparedProduct(product: input.product);
    }

    final uploadResult = await cloudinaryImageDatasource.uploadProductImage(
      selectedImage,
    );

    final productWithCloudinaryImage = Product(
      id: input.product.id,
      name: input.product.name,
      category: input.product.category,
      description: input.product.description,
      shortDescription: input.product.shortDescription,
      price: input.product.price,
      imageUrl: [uploadResult.secureUrl],
      imagePublicIds: [uploadResult.publicId],
    );

    return _PreparedProduct(
      product: productWithCloudinaryImage,
      uploadResult: uploadResult,
    );
  }

  Future<void> _rollbackUpload(CloudinaryUploadResult? uploadResult) async {
    if (uploadResult == null) {
      return;
    }

    try {
      await cloudinaryImageDatasource.deleteProductImage(uploadResult.publicId);
    } catch (_) {
      // Rollback tidak boleh menutupi error utama mutation.
    }
  }

  String _readError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }
}

class _PreparedProduct {
  final Product product;
  final CloudinaryUploadResult? uploadResult;

  const _PreparedProduct({required this.product, this.uploadResult});
}
