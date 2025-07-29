import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart.dart';
import '../../../domain/entities/cart_item.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateCartItemQuantity>(_onUpdateQty);
    on<ClearCart>(_onClearCart);
    on<ApplyCoupon>(_onApplyCoupon);
    on<RemoveCoupon>(_onRemoveCoupon);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cart = await repository.getCart();
      emit(CartLoaded(cart: cart));
    } catch (e) {
      emit(CartError(message: 'Failed to load cart'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        final updated = await repository.addToCart(
          event.menuItem,
          quantity: event.quantity,
          specialInstructions: event.specialInstructions,
          selectedIngredients: event.selectedIngredients,
        );
        emit(CartLoaded(cart: updated));
      } catch (_) {
        emit(CartError(message: 'Failed to add item'));
      }
    }
  }

  Future<void> _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        final updated = await repository.removeFromCart(event.cartItemId);
        emit(CartLoaded(cart: updated));
      } catch (_) {
        emit(CartError(message: 'Failed to remove item'));
      }
    }
  }

  Future<void> _onUpdateQty(UpdateCartItemQuantity event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        final updated = await repository.updateCartItemQuantity(event.cartItemId, event.quantity);
        emit(CartLoaded(cart: updated));
      } catch (_) {
        emit(CartError(message: 'Failed to update quantity'));
      }
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final cleared = await repository.clearCart();
      emit(CartLoaded(cart: cleared));
    } catch (_) {
      emit(CartError(message: 'Failed to clear cart'));
    }
  }

  Future<void> _onApplyCoupon(ApplyCoupon event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded) {
      emit(CartLoading());
      try {
        final updated = await repository.applyCoupon(event.couponCode);
        if (updated.discount > 0) {
          emit(CouponApplied(cart: updated, couponCode: event.couponCode));
        } else {
          emit(const CouponError(message: 'Invalid coupon'));
        }
      } catch (_) {
        emit(CartError(message: 'Failed to apply coupon'));
      }
    }
  }

  Future<void> _onRemoveCoupon(RemoveCoupon event, Emitter<CartState> emit) async {
    final currentState = state;
    if (currentState is CartLoaded || currentState is CouponApplied) {
      emit(CartLoading());
      try {
        final updated = await repository.removeCoupon();
        emit(CartLoaded(cart: updated));
      } catch (_) {
        emit(CartError(message: 'Failed to remove coupon'));
      }
    }
  }
}
