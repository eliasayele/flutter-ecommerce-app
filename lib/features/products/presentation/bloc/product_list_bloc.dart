import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_products_usecase.dart';
import '../../data/models/product_model.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

@injectable
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final GetProductsUseCase _getProductsUseCase;

  List<ProductModel> _allProducts = [];
  static const int _productsPerPage = 10;

  ProductListBloc(this._getProductsUseCase) : super(ProductListInitial()) {
    on<FetchProductsRequested>(_onFetchProductsRequested);
    on<FetchMoreProductsRequested>(_onFetchMoreProductsRequested);
    on<RefreshProductsRequested>(_onRefreshProductsRequested);
  }

  Future<void> _onFetchProductsRequested(
    FetchProductsRequested event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading());

    try {
      // Fetch all products from API
      _allProducts = await _getProductsUseCase.call();

      // Get first page
      final firstPageProducts = _getProductsPage(0);
      final hasReachedMax =
          firstPageProducts.length < _productsPerPage ||
          firstPageProducts.length >= _allProducts.length;

      emit(
        ProductListLoaded(
          products: firstPageProducts,
          hasReachedMax: hasReachedMax,
        ),
      );
    } catch (e) {
      emit(ProductListError(error: e.toString()));
    }
  }

  Future<void> _onFetchMoreProductsRequested(
    FetchMoreProductsRequested event,
    Emitter<ProductListState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProductListLoaded && !currentState.hasReachedMax) {
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        // Simulate pagination by getting next batch from cached products
        final currentProducts = currentState.products;
        final nextPageProducts = _getProductsPage(currentProducts.length);

        if (nextPageProducts.isNotEmpty) {
          final allLoadedProducts = [...currentProducts, ...nextPageProducts];
          final hasReachedMax = allLoadedProducts.length >= _allProducts.length;

          emit(
            ProductListLoaded(
              products: allLoadedProducts,
              hasReachedMax: hasReachedMax,
              isLoadingMore: false,
            ),
          );
        } else {
          emit(
            currentState.copyWith(hasReachedMax: true, isLoadingMore: false),
          );
        }
      } catch (e) {
        emit(ProductListError(error: e.toString()));
      }
    }
  }

  Future<void> _onRefreshProductsRequested(
    RefreshProductsRequested event,
    Emitter<ProductListState> emit,
  ) async {
    _allProducts.clear();
    add(const FetchProductsRequested());
  }

  List<ProductModel> _getProductsPage(int startIndex) {
    if (startIndex >= _allProducts.length) return [];

    final endIndex = (startIndex + _productsPerPage).clamp(
      0,
      _allProducts.length,
    );
    return _allProducts.sublist(startIndex, endIndex);
  }
}
