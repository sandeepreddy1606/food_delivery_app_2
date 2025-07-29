import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../entities/menu_item.dart';

abstract class CartRepository {
  Future<Cart> getCart();
  Future<Cart> addToCart(MenuItem menuItem,
      {int quantity,
      String? specialInstructions,
      List<String>? selectedIngredients});
  Future<Cart> removeFromCart(String cartItemId);
  Future<Cart> updateCartItemQuantity(String cartItemId, int quantity);
  Future<Cart> clearCart();
  Future<Cart> applyCoupon(String couponCode);
  Future<Cart> removeCoupon();
  Future<bool> saveCart(Cart cart);
}
