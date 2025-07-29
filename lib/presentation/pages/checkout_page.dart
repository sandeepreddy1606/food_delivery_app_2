import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/delivery_address.dart';
import '../../domain/entities/payment_method.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/checkout/checkout_event.dart';
import '../bloc/checkout/checkout_state.dart';
import '../widgets/checkout_item_widget.dart';
import '../widgets/payment_method_widget.dart';
import 'address_selection_page.dart';
import 'payment_method_selection_page.dart';

class CheckoutPage extends StatefulWidget {
  final List<OrderItem> items;
  const CheckoutPage({super.key, required this.items});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    super.initState();
    // Load initial checkout items
    context.read<CheckoutBloc>().add(LoadCheckoutData(widget.items));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Order items list
                    ...state.items.map((e) => CheckoutItemWidget(item: e)),
                    const Divider(),

                    // Address selection
                    ListTile(
                      title: const Text('Delivery Address'),
                      subtitle: Text(
                        state.selectedAddress?.label ?? 'Select address',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final DeliveryAddress? picked =
                            await Navigator.push<DeliveryAddress>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddressSelectionPage(),
                          ),
                        );
                        if (picked != null) {
                          context
                              .read<CheckoutBloc>()
                              .add(SelectAddress(picked));
                        }
                      },
                    ),
                    const Divider(),

                    // Payment method selection
                    ListTile(
                      title: const Text('Payment Method'),
                      subtitle: Text(
                        state.selectedPayment?.displayName ??
                            'Select payment method',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        final PaymentMethod? picked =
                            await Navigator.push<PaymentMethod>(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const PaymentMethodSelectionPage(),
                          ),
                        );
                        if (picked != null) {
                          context
                              .read<CheckoutBloc>()
                              .add(SelectPaymentMethod(picked));
                        }
                      },
                    ),
                    const Divider(),

                    // Place Order button
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: ElevatedButton(
                        onPressed: state.isPlacingOrder ||
                                state.selectedAddress == null ||
                                state.selectedPayment == null
                            ? null
                            : () {
                                context
                                    .read<CheckoutBloc>()
                                    .add(const PlaceOrder());
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.orange,
                        ),
                        child: state.isPlacingOrder
                            ? const CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              )
                            : const Text('Place Order'),
                      ),
                    ),

                    // Error message
                    if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
