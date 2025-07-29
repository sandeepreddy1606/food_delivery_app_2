import 'cart_item.dart';

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String? couponCode;
  final double discount;

  Cart({
    required this.items,
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.deliveryFee = 0.0,
    this.total = 0.0,
    this.couponCode,
    this.discount = 0.0,
  });

  /// Factory for an empty cart.
  factory Cart.empty() {
    return Cart(items: []);
  }

  /// Factory that calculates all fields from items, coupon, and discount.
  factory Cart.fromItems(List<CartItem> items, {String? couponCode, double discount = 0.0}) {
    final subtotal = items.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * 0.08; // 8% tax
    final deliveryFee = items.isEmpty ? 0.0 : 2.99;
    final total = subtotal + tax + deliveryFee - discount;

    return Cart(
      items: items,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
      couponCode: couponCode,
      discount: discount,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  Cart copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    String? couponCode,
    double? discount,
  }) {
    return Cart(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      couponCode: couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cart &&
        other.items == items &&
        other.subtotal == subtotal &&
        other.tax == tax &&
        other.deliveryFee == deliveryFee &&
        other.total == total &&
        other.couponCode == couponCode &&
        other.discount == discount;
  }

  @override
  int get hashCode {
    return items.hashCode ^
        subtotal.hashCode ^
        tax.hashCode ^
        deliveryFee.hashCode ^
        total.hashCode ^
        couponCode.hashCode ^
        discount.hashCode;
  }
}
