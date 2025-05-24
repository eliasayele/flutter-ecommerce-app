import 'package:equatable/equatable.dart';

import '../../data/models/product_model.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<ProductModel> products;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ProductListLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [products, hasReachedMax, isLoadingMore];

  ProductListLoaded copyWith({
    List<ProductModel>? products,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ProductListLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class ProductListError extends ProductListState {
  final String error;

  const ProductListError({required this.error});

  @override
  List<Object?> get props => [error];
}
