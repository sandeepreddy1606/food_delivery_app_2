import '../../domain/entities/delivery_address.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String? email; // Email can be null
  final String? phone; // Added phone field
  final String? photoUrl;
  final DeliveryAddress? defaultAddress;

  UserModel({
    required this.uid,
    this.displayName = '',
    this.email,
    this.phone,
    this.photoUrl,
    this.defaultAddress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?, // Read phone from json
      photoUrl: json['photoUrl'] as String?,
      defaultAddress: json['defaultAddress'] != null
          ? DeliveryAddress.fromJson(
              json['defaultAddress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'phone': phone, // Add phone to json
      'photoUrl': photoUrl,
      'defaultAddress': defaultAddress?.toJson(),
    };
  }

  // Helper to create a copy with updated values
  UserModel copyWith({
    String? displayName,
    String? phone,
    String? photoUrl,
    DeliveryAddress? defaultAddress,
  }) {
    return UserModel(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }
}
