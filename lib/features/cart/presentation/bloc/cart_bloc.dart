import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

@singleton
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository _cartRepository;

  CartBloc(this._cartRepository) : super(CartInitial()) {
    on<LoadCartRequested>(_onLoadCartRequested);
    on<AddToCartRequested>(_onAddToCartRequested);
    on<RemoveFromCartRequested>(_onRemoveFromCartRequested);
    on<UpdateQuantityRequested>(_onUpdateQuantityRequested);
    on<ClearCartRequested>(_onClearCartRequested);
  }

  Future<void> _onLoadCartRequested(
    LoadCartRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final items = await _cartRepository.getCartItems();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError('Failed to load cart: ${e.toString()}'));
    }
  }

  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;

    // Handle adding to cart from any state
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));
    } else {
      // If cart is not loaded, emit loading state first
      emit(CartLoading());
    }

    try {
      final cartItem = CartItemModel(
        product: event.product,
        quantity: event.quantity,
      );

      await _cartRepository.addToCart(cartItem);
      final updatedItems = await _cartRepository.getCartItems();
      emit(CartLoaded(items: updatedItems));
    } catch (e) {
      emit(CartError('Failed to add item to cart: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromCartRequested(
    RemoveFromCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        await _cartRepository.removeFromCart(event.productId);
        final updatedItems = await _cartRepository.getCartItems();
        emit(CartLoaded(items: updatedItems));
      } catch (e) {
        emit(CartError('Failed to remove item from cart: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateQuantityRequested(
    UpdateQuantityRequested event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        await _cartRepository.updateQuantity(event.productId, event.quantity);
        final updatedItems = await _cartRepository.getCartItems();
        emit(CartLoaded(items: updatedItems));
      } catch (e) {
        emit(CartError('Failed to update quantity: ${e.toString()}'));
      }
    }
  }

  Future<void> _onClearCartRequested(
    ClearCartRequested event,
    Emitter<CartState> emit,
  ) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        await _cartRepository.clearCart();
        emit(const CartLoaded(items: []));
      } catch (e) {
        emit(CartError('Failed to clear cart: ${e.toString()}'));
      }
    }
  }
}
