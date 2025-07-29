import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;
  CartRepositoryImpl({required this.localDataSource});

  @override
  Future<Cart> getCart() => localDataSource.getCart();

  @override
  Future<Cart> addToCart(MenuItem menuItem,
      {int quantity = 1,
      String? specialInstructions,
      List<String>? selectedIngredients}) async {
    final cart = await localDataSource.getCart();
    final items = List<CartItem>.from(cart.items);
    final idx = items.indexWhere((ci) => ci.menuItem.id == menuItem.id);
    if (idx != -1) {
      final existing = items[idx];
      items[idx] = existing.copyWith(
        quantity: existing.quantity + quantity,
        specialInstructions: specialInstructions ?? existing.specialInstructions,
        selectedIngredients: selectedIngredients ?? existing.selectedIngredients,
      );
    } else {
      items.add(CartItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        menuItem: menuItem,
        quantity: quantity,
        specialInstructions: specialInstructions,
        selectedIngredients: selectedIngredients ?? [],
        addedAt: DateTime.now(),
      ));
    }
    final updated = Cart.fromItems(items, couponCode: cart.couponCode, discount: cart.discount);
    await localDataSource.saveCart(updated);
    return updated;
  }

  @override
  Future<Cart> removeFromCart(String cartItemId) async {
    final cart = await localDataSource.getCart();
    final items = cart.items.where((ci) => ci.id != cartItemId).toList();
    final updated = Cart.fromItems(items, couponCode: cart.couponCode, discount: cart.discount);
    await localDataSource.saveCart(updated);
    return updated;
  }

  @override
  Future<Cart> updateCartItemQuantity(String cartItemId, int quantity) async {
    final cart = await localDataSource.getCart();
    final items = List<CartItem>.from(cart.items);
    final idx = items.indexWhere((ci) => ci.id == cartItemId);
    if (idx != -1) {
      if (quantity <= 0) {
        items.removeAt(idx);
      } else {
        items[idx] = items[idx].copyWith(quantity: quantity);
      }
    }
    final updated = Cart.fromItems(items, couponCode: cart.couponCode, discount: cart.discount);
    await localDataSource.saveCart(updated);
    return updated;
  }

  @override
  Future<Cart> clearCart() async {
    await localDataSource.clearCart();
    return Cart.empty();
  }

  @override
  Future<Cart> applyCoupon(String couponCode) async {
    final cart = await localDataSource.getCart();
    double discount = 0.0;
    if (couponCode == 'WELCOME10') discount = cart.subtotal * 0.1;
    if (couponCode == 'FREESHIP') discount = cart.deliveryFee;
    final updated = Cart.fromItems(cart.items, couponCode: couponCode, discount: discount);
    await localDataSource.saveCart(updated);
    return updated;
  }

  @override
  Future<Cart> removeCoupon() async {
    final cart = await localDataSource.getCart();
    final updated = Cart.fromItems(cart.items, couponCode: null, discount: 0.0);
    await localDataSource.saveCart(updated);
    return updated;
  }

  @override
  Future<bool> saveCart(Cart cart) => localDataSource.saveCart(cart);
}
