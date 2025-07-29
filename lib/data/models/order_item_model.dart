import '../../domain/entities/order_item.dart';
import '../../domain/entities/menu_item.dart';
import 'menu_item_model.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required String id,
    required MenuItemModel menuItem,
    required int quantity,
    required double totalPrice,
  }) : super(
          id: id,
          menuItem: menuItem,
          quantity: quantity,
          totalPrice: totalPrice,
        );

  /// Convert a domain [OrderItem] into a data [OrderItemModel]
  factory OrderItemModel.fromOrderItem(OrderItem item) {
    // Convert MenuItem entity to MenuItemModel
    final menuModel = item.menuItem is MenuItemModel
        ? item.menuItem as MenuItemModel
        : MenuItemModel.fromMenuItem(item.menuItem);
    return OrderItemModel(
      id: item.id,
      menuItem: menuModel,
      quantity: item.quantity,
      totalPrice: item.totalPrice,
    );
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      menuItem: MenuItemModel.fromJson(json['menuItem'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      totalPrice: (json['totalPrice'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'menuItem': (menuItem as MenuItemModel).toJson(),
        'quantity': quantity,
        'totalPrice': totalPrice,
      };
}
