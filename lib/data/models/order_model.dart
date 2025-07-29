import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/delivery_address.dart';
import '../../domain/entities/payment_method.dart';
import 'order_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required String id,
    required List<OrderItem> items,
    required DeliveryAddress address,
    required PaymentMethod payment,
    required double subtotal,
    required double tax,
    required double deliveryFee,
    required double total,
    required OrderStatus status,
    required DateTime placedAt,
  }) : super(
          id: id,
          items: items,
          address: address,
          payment: payment,
          subtotal: subtotal,
          tax: tax,
          deliveryFee: deliveryFee,
          total: total,
          status: status,
          placedAt: placedAt,
        );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse nested address
    final addrJson = json['address'] as Map<String, dynamic>;
    final address = DeliveryAddress(
      id: addrJson['id'] as String,
      label: addrJson['label'] as String,
      street: addrJson['street'] as String,
      city: addrJson['city'] as String,
      state: addrJson['state'] as String,
      zipCode: addrJson['zipCode'] as String,
      latitude: (addrJson['latitude'] as num).toDouble(),
      longitude: (addrJson['longitude'] as num).toDouble(),
    );

    // Parse items list with null-safety
    final itemsJson = json['items'] as List<dynamic>?;
    final items = itemsJson == null
        ? <OrderItem>[]
        : itemsJson
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList();

    // Parse payment method
    final payJson = json['payment'] as Map<String, dynamic>;
    final payment = PaymentMethod(
      id: payJson['id'] as String,
      type: PaymentType.values.firstWhere((e) => e.name == payJson['type']),
      displayName: payJson['displayName'] as String,
      lastFourDigits: payJson['lastFourDigits'] as String?,
    );

    // Parse status
    final status = OrderStatus.values.firstWhere(
      (e) => e.name == (json['status'] as String),
    );

    return OrderModel(
      id: json['id'] as String,
      items: items,
      address: address,
      payment: payment,
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: status,
      placedAt: DateTime.parse(json['placedAt'] as String),
    );
  }
}
