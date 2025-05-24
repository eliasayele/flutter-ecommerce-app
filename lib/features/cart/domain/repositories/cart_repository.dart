import '../../data/models/cart_item_model.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> addToCart(CartItemModel item);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
  Future<bool> isInCart(int productId);
}
