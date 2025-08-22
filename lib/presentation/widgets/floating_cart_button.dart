// lib/presentation/widgets/floating_cart_button.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../pages/cart_page.dart';

class FloatingCartButton extends StatelessWidget {
  const FloatingCartButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        // Simple approach - show button if cart is not empty
        // Adjust this condition based on your actual CartState
        bool hasItems = false;
        
        // Check your CartState - replace with your actual state check
        if (state.toString().contains('items') || 
            state.toString().contains('cart') ||
            state.runtimeType.toString().contains('Loaded')) {
          hasItems = true; // Adjust this logic based on your CartState
        }
        
        if (hasItems) {
          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_cart),
            label: const Text('Cart'),
            backgroundColor: Colors.orange,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
