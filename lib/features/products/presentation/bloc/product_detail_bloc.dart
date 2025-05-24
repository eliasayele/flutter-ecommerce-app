import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_product_by_id_usecase.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

@injectable
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final GetProductByIdUseCase _getProductByIdUseCase;

  ProductDetailBloc(this._getProductByIdUseCase)
    : super(ProductDetailInitial()) {
    on<FetchProductDetailRequested>(_onFetchProductDetailRequested);
    on<AddToCartRequested>(_onAddToCartRequested);
    on<ToggleWishlistRequested>(_onToggleWishlistRequested);
  }

  Future<void> _onFetchProductDetailRequested(
    FetchProductDetailRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(ProductDetailLoading());

    try {
      final product = await _getProductByIdUseCase.call(event.productId);

      emit(
        ProductDetailLoaded(
          product: product,
          isInWishlist: false, // TODO: Check if product is in wishlist
        ),
      );
    } catch (e) {
      emit(ProductDetailError(error: e.toString()));
    }
  }

  Future<void> _onAddToCartRequested(
    AddToCartRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      emit(currentState.copyWith(isAddingToCart: true));

      try {
        // TODO: Implement actual add to cart logic
        await Future.delayed(
          const Duration(milliseconds: 500),
        ); // Simulate API call

        emit(currentState.copyWith(isAddingToCart: false));
        emit(
          const AddToCartSuccess(
            message: 'Product added to cart successfully!',
          ),
        );

        // Return to loaded state after showing success
        await Future.delayed(const Duration(milliseconds: 100));
        emit(currentState.copyWith(isAddingToCart: false));
      } catch (e) {
        emit(currentState.copyWith(isAddingToCart: false));
        emit(
          ProductDetailError(
            error: 'Failed to add product to cart: ${e.toString()}',
          ),
        );
      }
    }
  }

  Future<void> _onToggleWishlistRequested(
    ToggleWishlistRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductDetailLoaded) {
      try {
        // TODO: Implement actual wishlist toggle logic
        final newWishlistStatus = !currentState.isInWishlist;

        emit(currentState.copyWith(isInWishlist: newWishlistStatus));
      } catch (e) {
        emit(
          ProductDetailError(
            error: 'Failed to update wishlist: ${e.toString()}',
          ),
        );
      }
    }
  }
}
