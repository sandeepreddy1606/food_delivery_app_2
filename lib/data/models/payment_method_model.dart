import '../../domain/entities/payment_method.dart';

class PaymentMethodModel extends PaymentMethod {
  const PaymentMethodModel({
    required String id,
    required PaymentType type,
    required String displayName,
    String? lastFourDigits,
  }) : super(id: id, type: type, displayName: displayName, lastFourDigits: lastFourDigits);

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      type: PaymentType.values.firstWhere((e) => e.toString() == json['type']),
      displayName: json['displayName'] as String,
      lastFourDigits: json['lastFourDigits'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toString(),
        'displayName': displayName,
        'lastFourDigits': lastFourDigits,
      };
}
