import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductDetailRequested extends ProductDetailEvent {
  final int productId;

  const FetchProductDetailRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddToCartRequested extends ProductDetailEvent {
  final int productId;
  final int quantity;

  const AddToCartRequested({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

class ToggleWishlistRequested extends ProductDetailEvent {
  final int productId;

  const ToggleWishlistRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
