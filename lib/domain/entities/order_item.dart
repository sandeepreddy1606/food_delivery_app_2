import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class OrderItem extends Equatable {
  final String id;
  final MenuItem menuItem;
  final int quantity;
  final double totalPrice;

  const OrderItem({
    required this.id,
    required this.menuItem,
    required this.quantity,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [id, menuItem, quantity, totalPrice];
}
