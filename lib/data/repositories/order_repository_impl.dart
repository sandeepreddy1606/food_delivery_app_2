import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/delivery_address.dart';
import '../../domain/entities/payment_method.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl({required this.remote});

  @override
  Future<Order> createOrder({
    required List<OrderItem> items,  // Now matches interface signature
    required DeliveryAddress address,
    required PaymentMethod payment,
  }) async {
    final model = await remote.createOrder(
      items: items,  // Pass OrderItem objects
      address: address,
      payment: payment,
    );
    return model;
  }

  @override
  Future<List<Order>> fetchOrderHistory() async {
    final models = await remote.fetchOrderHistory();
    return models;
  }

  @override
  Future<Order> fetchOrderById(String orderId) async {
    final model = await remote.fetchOrderById(orderId);
    return model;
  }
}
