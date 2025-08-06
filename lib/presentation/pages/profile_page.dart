import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/user_model.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Load the user's profile data when the page is opened
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
          if (state is ProfileLoaded) {
            // When data is loaded or updated, populate the text fields
            _nameController.text = state.user.displayName;
            _phoneController.text = (state.user.phone ?? '').replaceFirst('+91', '');
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileLoaded) {
            final user = state.user;
            final bool hasPhoneNumber = user.phone != null && user.phone!.isNotEmpty;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildProfileHeader(user),
                    const SizedBox(height: 24),
                    _buildAccountCard(user, hasPhoneNumber),
                    const SizedBox(height: 24),
                    _buildActionsCard(),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Could not load profile.'));
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.orange.shade100,
          backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
          child: user.photoUrl == null
              ? Text(
                  user.displayName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.orange),
                )
              : null,
        ),
        const SizedBox(height: 12),
        Text(user.displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(user.email ?? 'No email provided', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildAccountCard(UserModel user, bool hasPhoneNumber) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Account Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.isEmpty) ? 'Please enter your name' : null,
            ),
            const SizedBox(height: 16),
            // Phone Number Field
            TextFormField(
              controller: _phoneController,
              readOnly: hasPhoneNumber, // Lock the field if phone number already exists
              decoration: InputDecoration(
                labelText: 'Phone Number',
                prefixText: '+91 ',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: const OutlineInputBorder(),
                filled: hasPhoneNumber,
                fillColor: hasPhoneNumber ? Colors.grey[200] : null,
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (v) {
                if (!hasPhoneNumber && (v == null || v.length != 10)) {
                  return 'Please enter a valid 10-digit number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = user.copyWith(
                      displayName: _nameController.text.trim(),
                      // Only update phone if it was newly entered
                      phone: hasPhoneNumber ? user.phone : '+91${_phoneController.text.trim()}',
                    );
                    context.read<ProfileBloc>().add(UpdateProfile(updatedUser));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('SAVE CHANGES', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildListTile(Icons.history_outlined, 'Order History', () {}),
          const Divider(height: 1),
          _buildListTile(Icons.location_on_outlined, 'My Addresses', () {}),
          const Divider(height: 1),
          _buildListTile(Icons.logout, 'Logout', () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(color: color ?? Colors.black87)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
