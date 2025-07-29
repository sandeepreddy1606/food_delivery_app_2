import 'package:equatable/equatable.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/payment_method.dart';
import '../../../domain/entities/order_item.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadCheckoutData extends CheckoutEvent {
  final List<OrderItem> items;
  const LoadCheckoutData(this.items);
  @override
  List<Object?> get props => [items];
}

class SelectAddress extends CheckoutEvent {
  final DeliveryAddress address;
  const SelectAddress(this.address);
  @override
  List<Object?> get props => [address];
}

class SelectPaymentMethod extends CheckoutEvent {
  final PaymentMethod paymentMethod;
  const SelectPaymentMethod(this.paymentMethod);
  @override
  List<Object?> get props => [paymentMethod];
}

class ApplyPromoCode extends CheckoutEvent {
  final String code;
  const ApplyPromoCode(this.code);
  @override
  List<Object?> get props => [code];
}

class PlaceOrder extends CheckoutEvent {
  const PlaceOrder();
}
