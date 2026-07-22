import 'package:cross_file/cross_file.dart';

import '../../domain/entities/product.dart';

class ProductMutationInput {
  final Product product;
  final XFile? selectedImage;

  const ProductMutationInput({required this.product, this.selectedImage});
}
