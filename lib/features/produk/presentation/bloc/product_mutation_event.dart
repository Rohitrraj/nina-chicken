part of 'product_mutation_bloc.dart';

@immutable
sealed class ProductMutationEvent {}

class DoCreateProduct extends ProductMutationEvent {
  final ProductMutationInput input;

  DoCreateProduct(this.input);
}

class DoUpdateProduct extends ProductMutationEvent {
  final ProductMutationInput input;

  DoUpdateProduct(this.input);
}
