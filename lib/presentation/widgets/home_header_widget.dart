import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/address/address_bloc.dart';
import '../bloc/address/address_event.dart';
import '../bloc/address/address_state.dart';
import '../pages/address_selection_page.dart';
import '../pages/profile_page.dart';
import '../../domain/entities/address.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E7D5A), // Dark green
            Color(0xFF4CAF50), // Light green
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(
            children: [
              // Top Row with Location and Profile
              Row(
                children: [
                  // Location Section
                  Expanded(
                    child: BlocBuilder<AddressBloc, AddressState>(
                      builder: (context, state) {
                        String locationTitle = 'Home';
                        String locationSubtitle = '20.999-9., kedapa';
                        
                        if (state is AddressLoaded && state.selectedAddress != null) {
                          locationTitle = state.selectedAddress!.label;
                          locationSubtitle = state.selectedAddress!.shortAddress;
                        }
                        
                        return GestureDetector(
                          onTap: () async {
                            final Address? result = await Navigator.push<Address?>(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const AddressSelectionPage(),
                              ),
                            );
                            if (result != null) {
                              context.read<AddressBloc>().add(SelectAddress(result));
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      locationTitle,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      locationSubtitle,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 11,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white.withOpacity(0.8),
                                size: 16,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Profile Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && 
                              snapshot.data?.photoURL != null) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                snapshot.data!.photoURL!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 18,
                                  );
                                },
                              ),
                            );
                          }
                          return const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 18,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Search Bar
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Search functionality coming soon!')),
                  );
                },
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Icon(
                        Icons.search,
                        color: Colors.white.withOpacity(0.8),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Search your favourite dish',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}
