import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> fetchUserProfile();
  Future<void> updateUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  UserRemoteDataSourceImpl({required this.firestore});

  Future<String> get _uid async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('Not authenticated');
    return user.uid;
  }

  @override
  Future<UserModel> fetchUserProfile() async {
    final uid = await _uid;
    final doc = await firestore.collection('users').doc(uid).get();
    if (!doc.exists) {
      // Create a default profile if none
      final defaultProfile = UserModel(uid: uid);
      await updateUserProfile(defaultProfile);
      return defaultProfile;
    }
    return UserModel.fromJson(doc.data()!..['uid']=uid);
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    await firestore.collection('users').doc(user.uid).set(user.toJson());
  }
}
