import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/wishlist_item_model.dart';
import '../../domain/repositories/wishlist_repository.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

@singleton
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistRepository _wishlistRepository;

  WishlistBloc(this._wishlistRepository) : super(WishlistInitial()) {
    on<LoadWishlistRequested>(_onLoadWishlistRequested);
    on<AddToWishlistRequested>(_onAddToWishlistRequested);
    on<RemoveFromWishlistRequested>(_onRemoveFromWishlistRequested);
    on<ToggleWishlistRequested>(_onToggleWishlistRequested);
    on<ClearWishlistRequested>(_onClearWishlistRequested);
    on<CheckWishlistStatusRequested>(_onCheckWishlistStatusRequested);
  }

  Future<void> _onLoadWishlistRequested(
    LoadWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());
    try {
      final items = await _wishlistRepository.getWishlistItems();
      emit(WishlistLoaded(items: items));
    } catch (e) {
      emit(WishlistError('Failed to load wishlist: ${e.toString()}'));
    }
  }

  Future<void> _onAddToWishlistRequested(
    AddToWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        final wishlistItem = WishlistItemModel(
          product: event.product,
          addedAt: DateTime.now(),
        );

        await _wishlistRepository.addToWishlist(wishlistItem);
        final updatedItems = await _wishlistRepository.getWishlistItems();
        emit(WishlistLoaded(items: updatedItems));
      } catch (e) {
        emit(WishlistError('Failed to add item to wishlist: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRemoveFromWishlistRequested(
    RemoveFromWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        await _wishlistRepository.removeFromWishlist(event.productId);
        final updatedItems = await _wishlistRepository.getWishlistItems();
        emit(WishlistLoaded(items: updatedItems));
      } catch (e) {
        emit(
          WishlistError('Failed to remove item from wishlist: ${e.toString()}'),
        );
      }
    }
  }

  Future<void> _onToggleWishlistRequested(
    ToggleWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        final isInWishlist = await _wishlistRepository.isInWishlist(
          event.product.id,
        );

        if (isInWishlist) {
          await _wishlistRepository.removeFromWishlist(event.product.id);
        } else {
          final wishlistItem = WishlistItemModel(
            product: event.product,
            addedAt: DateTime.now(),
          );
          await _wishlistRepository.addToWishlist(wishlistItem);
        }

        final updatedItems = await _wishlistRepository.getWishlistItems();
        emit(WishlistLoaded(items: updatedItems));
      } catch (e) {
        emit(WishlistError('Failed to toggle wishlist: ${e.toString()}'));
      }
    }
  }

  Future<void> _onClearWishlistRequested(
    ClearWishlistRequested event,
    Emitter<WishlistState> emit,
  ) async {
    final currentState = state;
    if (currentState is WishlistLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      try {
        await _wishlistRepository.clearWishlist();
        emit(const WishlistLoaded(items: []));
      } catch (e) {
        emit(WishlistError('Failed to clear wishlist: ${e.toString()}'));
      }
    }
  }

  Future<void> _onCheckWishlistStatusRequested(
    CheckWishlistStatusRequested event,
    Emitter<WishlistState> emit,
  ) async {
    try {
      final isInWishlist = await _wishlistRepository.isInWishlist(
        event.productId,
      );
      emit(
        WishlistStatusLoaded(
          productId: event.productId,
          isInWishlist: isInWishlist,
        ),
      );
    } catch (e) {
      emit(WishlistError('Failed to check wishlist status: ${e.toString()}'));
    }
  }

  // Helper method to check if a product is in wishlist (can be called directly)
  Future<bool> isProductInWishlist(int productId) async {
    return await _wishlistRepository.isInWishlist(productId);
  }
}
