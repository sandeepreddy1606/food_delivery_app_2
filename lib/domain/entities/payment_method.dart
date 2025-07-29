import 'package:equatable/equatable.dart';

enum PaymentType { cash, creditCard, razorpay, paypal, stripe }

class PaymentMethod extends Equatable {
  final String id;
  final PaymentType type;
  final String displayName;
  final String? lastFourDigits;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.displayName,
    this.lastFourDigits,
  });

  @override
  List<Object?> get props => [id, type, displayName, lastFourDigits];
}
