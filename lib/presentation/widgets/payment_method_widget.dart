import 'package:flutter/material.dart';
import '../../../domain/entities/payment_method.dart';

class PaymentMethodWidget extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const PaymentMethodWidget({
    super.key,
    required this.method,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_iconForType(method.type)),
      title: Text(method.displayName),
      subtitle: method.lastFourDigits != null ? Text('**** ${method.lastFourDigits}') : null,
      trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
      onTap: onTap,
    );
  }

  IconData _iconForType(PaymentType type) {
    switch (type) {
      case PaymentType.cash:
        return Icons.money;
      case PaymentType.creditCard:
        return Icons.credit_card;
      case PaymentType.razorpay:
        return Icons.payment;
      case PaymentType.paypal:
        return Icons.account_balance_wallet;
      case PaymentType.stripe:
        return Icons.payment;
    }
  }
}
