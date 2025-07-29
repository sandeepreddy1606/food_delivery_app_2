import 'package:equatable/equatable.dart';
import '../../../domain/entities/order_item.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/payment_method.dart';

class CheckoutState extends Equatable {
  final List<OrderItem> items;
  final DeliveryAddress? selectedAddress;
  final PaymentMethod? selectedPayment;
  final String promoCode;
  final bool isPlacingOrder;
  final String? error;

  const CheckoutState({
    this.items = const [],
    this.selectedAddress,
    this.selectedPayment,
    this.promoCode = '',
    this.isPlacingOrder = false,
    this.error,
  });

  CheckoutState copyWith({
    List<OrderItem>? items,
    DeliveryAddress? selectedAddress,
    PaymentMethod? selectedPayment,
    String? promoCode,
    bool? isPlacingOrder,
    String? error,
  }) {
    return CheckoutState(
      items: items ?? this.items,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      promoCode: promoCode ?? this.promoCode,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [items, selectedAddress, selectedPayment, promoCode, isPlacingOrder, error];
}
