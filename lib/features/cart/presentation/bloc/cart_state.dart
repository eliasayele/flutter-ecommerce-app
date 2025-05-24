import 'package:equatable/equatable.dart';

import '../../data/models/cart_item_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItemModel> items;
  final bool isUpdating;

  const CartLoaded({required this.items, this.isUpdating = false});

  @override
  List<Object?> get props => [items, isUpdating];

  // Calculate total items count
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Calculate total price
  double get totalPrice =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Check if cart is empty
  bool get isEmpty => items.isEmpty;

  CartLoaded copyWith({List<CartItemModel>? items, bool? isUpdating}) {
    return CartLoaded(
      items: items ?? this.items,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object?> get props => [message];
}
