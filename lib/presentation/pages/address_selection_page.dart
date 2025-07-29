import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/delivery_address.dart';

class AddressSelectionPage extends StatelessWidget {
  final List<DeliveryAddress> mockAddresses = const [
    DeliveryAddress(
      id: 'addr1',
      label: 'Home',
      street: '123 Main St',
      city: 'Metropolis',
      state: 'NY',
      zipCode: '10001',
      latitude: 40.7128,
      longitude: -74.0060,
    ),
    DeliveryAddress(
      id: 'addr2',
      label: 'Work',
      street: '456 Market Ave',
      city: 'Metropolis',
      state: 'NY',
      zipCode: '10002',
      latitude: 40.7138,
      longitude: -74.0070,
    ),
  ];

  const AddressSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Delivery Address')),
      body: ListView.separated(
        itemCount: mockAddresses.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final addr = mockAddresses[index];
          return ListTile(
            title: Text(addr.label),
            subtitle: Text('${addr.street}, ${addr.city}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Return the selected address
              Navigator.pop<DeliveryAddress>(context, addr);
            },
          );
        },
      ),
    );
  }
}
