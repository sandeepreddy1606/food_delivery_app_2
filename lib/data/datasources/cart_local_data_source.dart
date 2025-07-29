import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/menu_item.dart';

abstract class CartLocalDataSource {
  Future<Cart> getCart();
  Future<bool> saveCart(Cart cart);
  Future<bool> clearCart();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const CART_KEY = 'food_delivery_cart';

  CartLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Cart> getCart() async {
    final cartJson = sharedPreferences.getString(CART_KEY);
    if (cartJson == null) return Cart.empty();
    try {
      final map = json.decode(cartJson);
      final itemsJson = map['items'] as List<dynamic>;
      final items = itemsJson.map((itemJson) {
        final mi = itemJson['menuItem'];
        return CartItem(
          id: itemJson['id'],
          menuItem: MenuItem(
            id: mi['id'],
            name: mi['name'],
            description: mi['description'],
            price: mi['price'],
            imageUrl: mi['imageUrl'],
            categoryId: mi['categoryId'],
            ingredients: List<String>.from(mi['ingredients']),
            isVegetarian: mi['isVegetarian'],
            isSpicy: mi['isSpicy'],
            preparationTime: mi['preparationTime'],
            rating: mi['rating'],
            calories: mi['calories'],
            isPopular: mi['isPopular'],
            isAvailable: mi['isAvailable'],
          ),
          quantity: itemJson['quantity'],
          specialInstructions: itemJson['specialInstructions'],
          selectedIngredients: List<String>.from(itemJson['selectedIngredients'] ?? []),
          addedAt: DateTime.parse(itemJson['addedAt']),
        );
      }).toList();
      return Cart.fromItems(items, couponCode: map['couponCode'], discount: map['discount'] ?? 0.0);
    } catch (_) {
      return Cart.empty();
    }
  }

  @override
  Future<bool> saveCart(Cart cart) async {
    final itemsJson = cart.items.map((ci) {
      return {
        'id': ci.id,
        'menuItem': {
          'id': ci.menuItem.id,
          'name': ci.menuItem.name,
          'description': ci.menuItem.description,
          'price': ci.menuItem.price,
          'imageUrl': ci.menuItem.imageUrl,
          'categoryId': ci.menuItem.categoryId,
          'ingredients': ci.menuItem.ingredients,
          'isVegetarian': ci.menuItem.isVegetarian,
          'isSpicy': ci.menuItem.isSpicy,
          'preparationTime': ci.menuItem.preparationTime,
          'rating': ci.menuItem.rating,
          'calories': ci.menuItem.calories,
          'isPopular': ci.menuItem.isPopular,
          'isAvailable': ci.menuItem.isAvailable,
        },
        'quantity': ci.quantity,
        'specialInstructions': ci.specialInstructions,
        'selectedIngredients': ci.selectedIngredients,
        'addedAt': ci.addedAt.toIso8601String(),
      };
    }).toList();
    final map = {
      'items': itemsJson,
      'couponCode': cart.couponCode,
      'discount': cart.discount,
    };
    return sharedPreferences.setString(CART_KEY, json.encode(map));
  }

  @override
  Future<bool> clearCart() async {
    return sharedPreferences.remove(CART_KEY);
  }
}
