import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

@LazySingleton(as: CartRepository)
class CartRepositoryImpl implements CartRepository {
  final SharedPreferences _sharedPreferences;

  static const String _cartKey = 'cart_items';

  const CartRepositoryImpl(this._sharedPreferences);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final cartJson = _sharedPreferences.getString(_cartKey);
      if (cartJson == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(cartJson);
      return jsonList.map((json) => CartItemModel.fromJson(json)).toList();
    } catch (e) {
      // If there's an error reading the data, return empty list
      return [];
    }
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final cartJson = json.encode(jsonList);
      await _sharedPreferences.setString(_cartKey, cartJson);
    } catch (e) {
      throw Exception('Failed to save cart items: $e');
    }
  }

  @override
  Future<void> addToCart(CartItemModel item) async {
    final items = await getCartItems();

    // Check if item already exists
    final existingIndex = items.indexWhere(
      (existingItem) => existingItem.product.id == item.product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if item exists
      final existingItem = items[existingIndex];
      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add new item if it doesn't exist
      items.add(item);
    }

    await saveCartItems(items);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.product.id == productId);
    await saveCartItems(items);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final items = await getCartItems();

    if (quantity <= 0) {
      // Remove item if quantity is 0 or less
      items.removeWhere((item) => item.product.id == productId);
    } else {
      // Update quantity
      final itemIndex = items.indexWhere(
        (item) => item.product.id == productId,
      );

      if (itemIndex != -1) {
        items[itemIndex] = items[itemIndex].copyWith(quantity: quantity);
      }
    }

    await saveCartItems(items);
  }

  @override
  Future<void> clearCart() async {
    await _sharedPreferences.remove(_cartKey);
  }

  @override
  Future<bool> isInCart(int productId) async {
    final items = await getCartItems();
    return items.any((item) => item.product.id == productId);
  }
}
