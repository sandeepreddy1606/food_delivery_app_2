import 'package:flutter/material.dart';
import '../../../domain/entities/order_item.dart';

class CheckoutItemWidget extends StatelessWidget {
  final OrderItem item;
  const CheckoutItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(item.menuItem.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
      title: Text(item.menuItem.name),
      subtitle: Text('x${item.quantity}'),
      trailing: Text('\$${item.totalPrice.toStringAsFixed(2)}'),
    );
  }
}
