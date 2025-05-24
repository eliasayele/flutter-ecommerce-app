import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/wishlist_repository.dart';
import '../models/wishlist_item_model.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final SharedPreferences _sharedPreferences;

  static const String _wishlistKey = 'wishlist_items';

  const WishlistRepositoryImpl(this._sharedPreferences);

  @override
  Future<List<WishlistItemModel>> getWishlistItems() async {
    try {
      final wishlistJson = _sharedPreferences.getString(_wishlistKey);
      if (wishlistJson == null) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(wishlistJson);
      return jsonList.map((json) => WishlistItemModel.fromJson(json)).toList();
    } catch (e) {
      // If there's an error reading the data, return empty list
      return [];
    }
  }

  @override
  Future<void> saveWishlistItems(List<WishlistItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      final wishlistJson = json.encode(jsonList);
      await _sharedPreferences.setString(_wishlistKey, wishlistJson);
    } catch (e) {
      throw Exception('Failed to save wishlist items: $e');
    }
  }

  @override
  Future<void> addToWishlist(WishlistItemModel item) async {
    final items = await getWishlistItems();

    // Check if item already exists
    final existingIndex = items.indexWhere(
      (existingItem) => existingItem.product.id == item.product.id,
    );

    if (existingIndex == -1) {
      items.add(item);
      await saveWishlistItems(items);
    }
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    final items = await getWishlistItems();
    items.removeWhere((item) => item.product.id == productId);
    await saveWishlistItems(items);
  }

  @override
  Future<void> clearWishlist() async {
    await _sharedPreferences.remove(_wishlistKey);
  }

  @override
  Future<bool> isInWishlist(int productId) async {
    final items = await getWishlistItems();
    return items.any((item) => item.product.id == productId);
  }
}
