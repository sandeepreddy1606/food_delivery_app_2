import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {  // Added missing generic type parameters
  final OrderRepository repository;

  OrderBloc({required this.repository}) : super(const OrderState()) {
    on<FetchOrders>(_onFetchOrders);
  }

  Future<void> _onFetchOrders(FetchOrders event, Emitter<OrderState> emit) async {  // Added proper type parameters and return type
    emit(state.copyWith(isLoading: true));
    try {
      final orders = await repository.fetchOrderHistory();
      emit(state.copyWith(orders: orders, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }  // Added missing closing brace
}
