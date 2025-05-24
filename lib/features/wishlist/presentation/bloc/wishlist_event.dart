import 'package:equatable/equatable.dart';

import '../../../products/data/models/product_model.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWishlistRequested extends WishlistEvent {}

class AddToWishlistRequested extends WishlistEvent {
  final ProductModel product;

  const AddToWishlistRequested({required this.product});

  @override
  List<Object?> get props => [product];
}

class RemoveFromWishlistRequested extends WishlistEvent {
  final int productId;

  const RemoveFromWishlistRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ToggleWishlistRequested extends WishlistEvent {
  final ProductModel product;

  const ToggleWishlistRequested({required this.product});

  @override
  List<Object?> get props => [product];
}

class ClearWishlistRequested extends WishlistEvent {}

class CheckWishlistStatusRequested extends WishlistEvent {
  final int productId;

  const CheckWishlistStatusRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
