import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'delivery_address.dart';
import 'payment_method.dart';

enum OrderStatus { pending, confirmed, preparing, outForDelivery, delivered }

class Order extends Equatable {
  final String id;
  final List<OrderItem> items;  // Added proper type parameter
  final DeliveryAddress address;
  final PaymentMethod payment;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime placedAt;

  const Order({
    required this.id,
    required this.items,
    required this.address,
    required this.payment,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.placedAt,
  });

  @override
  List<Object?> get props => [  // Fixed HTML entity and added proper type parameter
    id,
    items,
    address,
    payment,
    subtotal,
    tax,
    deliveryFee,
    total,
    status,
    placedAt,
  ];
}
