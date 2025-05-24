import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

abstract class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductModel product;
  final bool isInWishlist;
  final bool isAddingToCart;

  const ProductDetailLoaded({
    required this.product,
    this.isInWishlist = false,
    this.isAddingToCart = false,
  });

  @override
  List<Object?> get props => [product, isInWishlist, isAddingToCart];

  ProductDetailLoaded copyWith({
    ProductModel? product,
    bool? isInWishlist,
    bool? isAddingToCart,
  }) {
    return ProductDetailLoaded(
      product: product ?? this.product,
      isInWishlist: isInWishlist ?? this.isInWishlist,
      isAddingToCart: isAddingToCart ?? this.isAddingToCart,
    );
  }
}

class ProductDetailError extends ProductDetailState {
  final String error;

  const ProductDetailError({required this.error});

  @override
  List<Object?> get props => [error];
}

class AddToCartSuccess extends ProductDetailState {
  final String message;

  const AddToCartSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
