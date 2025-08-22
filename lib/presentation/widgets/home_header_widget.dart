// lib/presentation/widgets/home_header_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/injection_container.dart' as di;
import '../bloc/address/address_bloc.dart';
import '../bloc/address/address_event.dart';
import '../bloc/address/address_state.dart';
import '../pages/address_selection_page.dart';
import '../../domain/entities/address.dart';

class HomeHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressBloc>(
      create: (_) => di.sl<AddressBloc>()..add(LoadAddresses()),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            // Default texts
            String labelText = 'DELIVERING TO';
            String locationText = 'Current Location';

            if (state is AddressLoaded && state.selectedAddress != null) {
              locationText = state.selectedAddress!.label;
            }

            return InkWell(
              onTap: () async {
                final Address? result = await Navigator.push<Address?>(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider.value(
                      value: context.read<AddressBloc>(),
                      child: const AddressSelectionPage(),
                    ),
                  ),
                );
                if (result != null) {
                  context.read<AddressBloc>().add(SelectAddress(result));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          locationText,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.orange),
            onPressed: () {
              // profile action
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
