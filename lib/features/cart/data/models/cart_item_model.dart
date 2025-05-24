import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../products/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required ProductModel product,
    required int quantity,
  }) = _CartItemModel;

  const CartItemModel._();

  // Calculate total price for this cart item
  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
