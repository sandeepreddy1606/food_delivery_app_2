import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/order_repository.dart';
import '../../../domain/entities/order_item.dart';
import '../../../domain/entities/delivery_address.dart';
import '../../../domain/entities/payment_method.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';
import '../order/order_event.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {  // Added type parameters
  final OrderRepository orderRepo;
  final _orderBloc;

  CheckoutBloc({required this.orderRepo, required orderBloc})
      : _orderBloc = orderBloc,
        super(const CheckoutState()) {
    on<LoadCheckoutData>(_onLoadData);
    on<SelectAddress>(_onSelectAddress);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<ApplyPromoCode>(_onApplyPromoCode);
    on<PlaceOrder>(_onPlaceOrder);
  }

  void _onLoadData(LoadCheckoutData event, Emitter<CheckoutState> emit) {  // Added type parameter
    emit(state.copyWith(items: event.items));
  }

  void _onSelectAddress(SelectAddress event, Emitter<CheckoutState> emit) {  // Added type parameter
    emit(state.copyWith(selectedAddress: event.address));
  }

  void _onSelectPaymentMethod(SelectPaymentMethod event, Emitter<CheckoutState> emit) {  // Added type parameter
    emit(state.copyWith(selectedPayment: event.paymentMethod));
  }

  void _onApplyPromoCode(ApplyPromoCode event, Emitter<CheckoutState> emit) {  // Added type parameter
    emit(state.copyWith(promoCode: event.code));
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<CheckoutState> emit) async {  // Added type parameter and return type
    if (state.selectedAddress == null || state.selectedPayment == null) {
      emit(state.copyWith(error: 'Please select address and payment method.'));
      return;
    }

    emit(state.copyWith(isPlacingOrder: true));
    try {
      // Pass OrderItem objects directly to repository
      final order = await orderRepo.createOrder(
        items: state.items,  // Pass actual OrderItem objects instead of IDs
        address: state.selectedAddress!,
        payment: state.selectedPayment!,
      );
      
      // Notify OrderBloc to refresh history
      _orderBloc.add(FetchOrders());
      emit(state.copyWith(isPlacingOrder: false));
    } catch (e) {
      emit(state.copyWith(isPlacingOrder: false, error: e.toString()));
    }
  }
}
