import '../entities/order.dart';
import '../entities/order_item.dart';
import '../entities/delivery_address.dart';
import '../entities/payment_method.dart';

abstract class OrderRepository {
  Future<Order> createOrder({
    required List<OrderItem> items,  // Changed from List<String> cartItemIds
    required DeliveryAddress address,
    required PaymentMethod payment,
  });
  
  Future<List<Order>> fetchOrderHistory();
  
  Future<Order> fetchOrderById(String orderId);
}
