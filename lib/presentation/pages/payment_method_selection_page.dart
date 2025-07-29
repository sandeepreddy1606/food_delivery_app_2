import 'package:flutter/material.dart';
import '../../../domain/entities/payment_method.dart';

class PaymentMethodSelectionPage extends StatelessWidget {
  final List<PaymentMethod> methods = const [
    PaymentMethod(
      id: 'pm_cash',
      type: PaymentType.cash,
      displayName: 'Cash on Delivery',
      lastFourDigits: null,
    ),
    PaymentMethod(
      id: 'pm_card',
      type: PaymentType.creditCard,
      displayName: 'Visa **** 4242',
      lastFourDigits: '4242',
    ),
    PaymentMethod(
      id: 'pm_paypal',
      type: PaymentType.paypal,
      displayName: 'PayPal',
      lastFourDigits: null,
    ),
  ];

  const PaymentMethodSelectionPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Payment Method')),
      body: ListView.separated(
        itemCount: methods.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final method = methods[index];
          return ListTile(
            leading: Icon(_iconForType(method.type)),
            title: Text(method.displayName),
            subtitle: method.lastFourDigits != null
                ? Text('**** ${method.lastFourDigits}')
                : null,
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Return the selected payment method
              Navigator.pop<PaymentMethod>(context, method);
            },
          );
        },
      ),
    );
  }
}
