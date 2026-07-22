import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/datasources/cloudinary_image_datasource.dart';
import '../../data/model/cloudinary_upload_result.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';
import '../../domain/usecases/update_product.dart';
import '../models/product_mutation_input.dart';

part 'product_mutation_event.dart';
part 'product_mutation_state.dart';

class ProductMutationBloc
    extends Bloc<ProductMutationEvent, ProductMutationState> {
  final CreateProduct createProduct;
  final UpdateProduct updateProduct;
  final CloudinaryImageDatasource cloudinaryImageDatasource;

  ProductMutationBloc({
    required this.createProduct,
    required this.updateProduct,
    required this.cloudinaryImageDatasource,
  }) : super(ProductMutationInitial()) {
    on<DoCreateProduct>(_onCreateProduct);
    on<DoUpdateProduct>(_onUpdateProduct);
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

    final previousPublicIds = List<String>.from(
      event.input.product.imagePublicIds,
    );

    try {
      preparedProduct = await _prepareProduct(event.input);

      await updateProduct(preparedProduct.product);

      final newUpload = preparedProduct.uploadResult;
      var cleanupSucceeded = true;

      if (newUpload != null) {
        cleanupSucceeded = await _deleteCloudinaryImages(
          previousPublicIds,
          excludedPublicId: newUpload.publicId,
        );
      }

      emit(
        ProductMutationSuccess(
          cleanupSucceeded
              ? 'Product Successfully Updated!'
              : 'Produk berhasil diperbarui, tetapi '
                    'gambar lama gagal dibersihkan.',
        ),
      );
    } catch (error) {
      await _rollbackUpload(preparedProduct?.uploadResult);

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
      imageUrl: <String>[uploadResult.secureUrl],
      imagePublicIds: <String>[uploadResult.publicId],
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
      // Kegagalan rollback tidak boleh
      // menutupi error mutation utama.
    }
  }

  Future<bool> _deleteCloudinaryImages(
    Iterable<String> publicIds, {
    String? excludedPublicId,
  }) async {
    var allDeleted = true;

    final normalizedExcludedPublicId = excludedPublicId?.trim();

    final normalizedIds = publicIds
        .map((publicId) => publicId.trim())
        .where((publicId) => publicId.isNotEmpty)
        .toSet();

    for (final publicId in normalizedIds) {
      if (publicId == normalizedExcludedPublicId) {
        continue;
      }

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

class _PreparedProduct {
  final Product product;
  final CloudinaryUploadResult? uploadResult;

  const _PreparedProduct({required this.product, this.uploadResult});
}
