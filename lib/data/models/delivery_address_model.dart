import '../../domain/entities/delivery_address.dart';

class DeliveryAddressModel extends DeliveryAddress {
  const DeliveryAddressModel({
    required String id,
    required String label,
    required String street,
    required String city,
    required String state,
    required String zipCode,
    required double latitude,
    required double longitude,
  }) : super(
          id: id,
          label: label,
          street: street,
          city: city,
          state: state,
          zipCode: zipCode,
          latitude: latitude,
          longitude: longitude,
        );

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
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

  Map<String, dynamic> toJson() => {
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
