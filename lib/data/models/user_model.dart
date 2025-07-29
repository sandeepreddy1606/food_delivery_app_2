import '../../domain/entities/delivery_address.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String? photoUrl;
  final DeliveryAddress? defaultAddress;

  UserModel({
    required this.uid,
    this.displayName = '',
    this.photoUrl,
    this.defaultAddress,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String? ?? '',
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
      'photoUrl': photoUrl,
      'defaultAddress': defaultAddress?.toJson(),
    };
  }
}
