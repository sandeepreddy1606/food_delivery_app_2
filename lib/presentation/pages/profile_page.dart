import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../bloc/profile/profile_bloc.dart';
import '../bloc/profile/profile_event.dart';
import '../bloc/profile/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override void initState() {
    super.initState();
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (c, state) {
          if (state is ProfileError)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red)
            );
        },
        builder: (c, state) {
          if (state is ProfileLoading) return const Center(child: CircularProgressIndicator());
          if (state is ProfileLoaded) {
            _nameCtrl.text = state.user.displayName;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  // Avatar
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: state.user.photoUrl != null
                      ? NetworkImage(state.user.photoUrl!)
                      : null,
                    child: state.user.photoUrl==null ? const Icon(Icons.person, size: 50) : null,
                  ),
                  const SizedBox(height: 16),
                  // Name Field
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) => (v==null||v.isEmpty) ? 'Enter a name' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updated = UserModel(
                          uid: state.user.uid,
                          displayName: _nameCtrl.text.trim(),
                          photoUrl: state.user.photoUrl,
                          defaultAddress: state.user.defaultAddress,
                        );
                        context.read<ProfileBloc>().add(UpdateProfile(updated));
                      }
                    },
                    child: const Text('Save Changes')
                  ),
                ]),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
