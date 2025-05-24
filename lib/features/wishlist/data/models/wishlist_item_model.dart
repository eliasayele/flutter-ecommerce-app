import 'package:equatable/equatable.dart';

import '../../../products/data/models/product_model.dart';

class WishlistItemModel extends Equatable {
  final ProductModel product;
  final DateTime addedAt;

  const WishlistItemModel({required this.product, required this.addedAt});

  @override
  List<Object?> get props => [product, addedAt];

  WishlistItemModel copyWith({ProductModel? product, DateTime? addedAt}) {
    return WishlistItemModel(
      product: product ?? this.product,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {'product': product.toJson(), 'addedAt': addedAt.toIso8601String()};
  }

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      product: ProductModel.fromJson(json['product']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }
}
