part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final MenuItem menuItem;
  final int quantity;
  final String specialInstructions;
  final List<String> selectedIngredients;

  const AddToCart({
    required this.menuItem,
    this.quantity = 1,
    this.specialInstructions = '',
    this.selectedIngredients = const [],
  });

  @override
  List<Object> get props => [menuItem, quantity, specialInstructions, selectedIngredients];
}

class RemoveFromCart extends CartEvent {
  final String cartItemId;

  const RemoveFromCart(this.cartItemId);

  @override
  List<Object> get props => [cartItemId];
}

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int quantity;

  const UpdateCartItemQuantity(this.cartItemId, this.quantity);

  @override
  List<Object> get props => [cartItemId, quantity];
}

class ClearCart extends CartEvent {}

class ApplyCoupon extends CartEvent {
  final String couponCode;

  const ApplyCoupon(this.couponCode);

  @override
  List<Object> get props => [couponCode];
}

class RemoveCoupon extends CartEvent {}
