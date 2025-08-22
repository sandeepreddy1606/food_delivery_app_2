import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/address.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/address/address_event.dart';
import '../bloc/address/address_state.dart';
import 'add_address_page.dart';

class AddressSelectionPage extends StatelessWidget {
  const AddressSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Delivery Address'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddressOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            }

            if (state is AddressLoaded) {
              return Column(
                children: [
                  // Current Location Option
                  Container(
                    color: Colors.orange.withOpacity(0.1),
                    child: ListTile(
                      leading: const Icon(Icons.my_location, color: Colors.orange),
                      title: const Text('Use Current Location'),
                      subtitle: const Text('Get your current location automatically'),
                      trailing: const Icon(Icons.gps_fixed),
                      onTap: () {
                        context.read<AddressBloc>().add(GetCurrentLocation());
                      },
                    ),
                  ),
                  
                  const Divider(height: 1),
                  
                  // Add New Address Option
                  ListTile(
                    leading: const Icon(Icons.add_location, color: Colors.orange),
                    title: const Text('Add New Address'),
                    subtitle: const Text('Save a new delivery address'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () async {
                      final result = await Navigator.push<Address>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAddressPage(),
                        ),
                      );
                      
                      if (result != null) {
                        context.read<AddressBloc>().add(AddNewAddress(result));
                      }
                    },
                  ),
                  
                  const Divider(height: 1),
                  
                  // Saved Addresses
                  if (state.addresses.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Saved Addresses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.addresses.length,
                      itemBuilder: (context, index) {
                        final address = state.addresses[index];
                        final isSelected = state.selectedAddress?.id == address.id;
                        
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          elevation: isSelected ? 4 : 1,
                          color: isSelected ? Colors.orange.withOpacity(0.1) : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isSelected ? Colors.orange : Colors.grey,
                              child: Icon(
                                _getIconForAddressType(address.label),
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              address.label,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.shortAddress,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (address.isDefault)
                                  const Text(
                                    'Default Address',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'select':
                                    context.read<AddressBloc>().add(SelectAddress(address));
                                    Navigator.pop(context, address);
                                    break;
                                  case 'edit':
                                    _editAddress(context, address);
                                    break;
                                  case 'delete':
                                    _deleteAddress(context, address);
                                    break;
                                  case 'default':
                                    context.read<AddressBloc>().add(SetDefaultAddress(address.id));
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'select',
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline),
                                      SizedBox(width: 8),
                                      Text('Select'),
                                    ],
                                  ),
                                ),
                                if (!address.isCurrentLocation) ...[
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit_outlined),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  if (!address.isDefault)
                                    const PopupMenuItem(
                                      value: 'default',
                                      child: Row(
                                        children: [
                                          Icon(Icons.star_outline),
                                          SizedBox(width: 8),
                                          Text('Set as Default'),
                                        ],
                                      ),
                                    ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete_outline, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            onTap: () {
                              context.read<AddressBloc>().add(SelectAddress(address));
                              Navigator.pop(context, address);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is AddressError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AddressBloc>().add(LoadAddresses());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('No addresses found'));
          },
        ),
      ),
    );
  }

  IconData _getIconForAddressType(String label) {
    switch (label.toLowerCase()) {
      case 'home':
        return Icons.home;
      case 'office':
      case 'work':
        return Icons.business;
      case 'current location':
        return Icons.my_location;
      default:
        return Icons.location_on;
    }
  }

  void _editAddress(BuildContext context, Address address) async {
    final result = await Navigator.push<Address>(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressPage(address: address),
      ),
    );
    
    if (result != null) {
      context.read<AddressBloc>().add(UpdateAddress(result));
    }
  }

  void _deleteAddress(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Address'),
        content: Text('Are you sure you want to delete ${address.label}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AddressBloc>().add(DeleteAddress(address.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
