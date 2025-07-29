import 'menu_item.dart';

class CartItem {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;
  final List<String> selectedIngredients;
  final DateTime addedAt;

  CartItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
    required this.selectedIngredients,
    required this.addedAt,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    String? id,
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
    List<String>? selectedIngredients,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      selectedIngredients: selectedIngredients ?? this.selectedIngredients,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
