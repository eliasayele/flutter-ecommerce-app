import '../../data/models/wishlist_item_model.dart';

abstract class WishlistRepository {
  Future<List<WishlistItemModel>> getWishlistItems();
  Future<void> saveWishlistItems(List<WishlistItemModel> items);
  Future<void> addToWishlist(WishlistItemModel item);
  Future<void> removeFromWishlist(int productId);
  Future<void> clearWishlist();
  Future<bool> isInWishlist(int productId);
}
