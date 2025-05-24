import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class FetchProductsRequested extends ProductListEvent {
  final int? limit;

  const FetchProductsRequested({this.limit});

  @override
  List<Object?> get props => [limit];
}

class FetchMoreProductsRequested extends ProductListEvent {}

class RefreshProductsRequested extends ProductListEvent {}
