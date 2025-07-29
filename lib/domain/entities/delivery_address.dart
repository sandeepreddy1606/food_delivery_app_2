import 'package:equatable/equatable.dart';

class DeliveryAddress extends Equatable {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  const DeliveryAddress({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  /// Creates a [DeliveryAddress] from a JSON map.
  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      zipCode: json['zipCode'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Converts this [DeliveryAddress] into a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object?> get props => [
        id,
        label,
        street,
        city,
        state,
        zipCode,
        latitude,
        longitude,
      ];
}
