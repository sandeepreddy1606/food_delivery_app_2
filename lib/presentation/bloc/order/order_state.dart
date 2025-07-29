import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';

class OrderState extends Equatable {
  final List<Order> orders;  // Added proper type parameter
  final bool isLoading;
  final String? error;

  const OrderState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });

  OrderState copyWith({
    List<Order>? orders,  // Added proper type parameter
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }  // Added missing closing brace

  @override
  List<Object?> get props => [orders, isLoading, error];  // Fixed HTML entity and added proper type parameter
}
