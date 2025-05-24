import 'package:equatable/equatable.dart';

import '../../../products/data/models/product_model.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class LoadCartRequested extends CartEvent {}

class AddToCartRequested extends CartEvent {
  final ProductModel product;
  final int quantity;

  const AddToCartRequested({required this.product, this.quantity = 1});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveFromCartRequested extends CartEvent {
  final int productId;

  const RemoveFromCartRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantityRequested extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateQuantityRequested({
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCartRequested extends CartEvent {}
