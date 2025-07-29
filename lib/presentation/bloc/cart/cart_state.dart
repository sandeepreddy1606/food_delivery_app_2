part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;

  const CartLoaded({required this.cart});

  @override
  List<Object> get props => [cart];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}

class CouponApplied extends CartState {
  final Cart cart;
  final String couponCode;

  const CouponApplied({required this.cart, required this.couponCode});

  @override
  List<Object> get props => [cart, couponCode];
}

class CouponError extends CartState {
  final String message;

  const CouponError({required this.message});

  @override
  List<Object> get props => [message];
}
