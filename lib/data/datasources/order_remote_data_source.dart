import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/order_model.dart';
import '../models/order_item_model.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/delivery_address.dart';
import '../../domain/entities/payment_method.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> createOrder({
    required List<OrderItem> items,
    required DeliveryAddress address,
    required PaymentMethod payment,
  });
  Future<List<OrderModel>> fetchOrderHistory();
  Future<OrderModel> fetchOrderById(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  // Wait for FirebaseAuth to initialize and return the current user
  Future<User> _getAuthenticatedUser() async {
    final current = FirebaseAuth.instance.currentUser;
    if (current != null) return current;
    final completer = Completer<User>();
    late StreamSubscription<User?> sub;
    sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      sub.cancel();
      if (user != null) {
        completer.complete(user);
      } else {
        completer.completeError(Exception('User not authenticated'));
      }
    });
    return completer.future;
  }

  @override
  Future<OrderModel> createOrder({
    required List<OrderItem> items,
    required DeliveryAddress address,
    required PaymentMethod payment,
  }) async {
    final user = await _getAuthenticatedUser();

    final subtotal = items.fold<double>(0.0, (sum, i) => sum + i.totalPrice);
    final tax = subtotal * 0.08;
    final deliveryFee = subtotal >= 25.0 ? 0.0 : 3.99;
    final total = subtotal + tax + deliveryFee;

    final data = {
      'userId': user.uid,
      'items': items
          .map((item) => OrderItemModel.fromOrderItem(item).toJson())
          .toList(),
      'address': {
        'id': address.id,
        'label': address.label,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'zipCode': address.zipCode,
        'latitude': address.latitude,
        'longitude': address.longitude,
      },
      'payment': {
        'id': payment.id,
        'type': payment.type.name,
        'displayName': payment.displayName,
        'lastFourDigits': payment.lastFourDigits,
      },
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': 'pending',
      'placedAt': FieldValue.serverTimestamp(),
    };

    final docRef = await firestore.collection('orders').add(data);
    final snap = await docRef.get();
    final json = snap.data()!..['id'] = docRef.id;
    final ts = snap.get('placedAt') as Timestamp;
    json['placedAt'] = ts.toDate().toIso8601String();
    return OrderModel.fromJson(json);
  }

  @override
  Future<List<OrderModel>> fetchOrderHistory() async {
    final user = await _getAuthenticatedUser();

    final query = await firestore
        .collection('orders')
        .where('userId', isEqualTo: user.uid)
        .orderBy('placedAt', descending: true)
        .get();

    return query.docs.map((doc) {
      final json = doc.data()!..['id'] = doc.id;
      final ts = doc.get('placedAt') as Timestamp;
      json['placedAt'] = ts.toDate().toIso8601String();
      return OrderModel.fromJson(json);
    }).toList();
  }

  @override
  Future<OrderModel> fetchOrderById(String orderId) async {
    final snap = await firestore.collection('orders').doc(orderId).get();
    final json = snap.data()!..['id'] = snap.id;
    final ts = snap.get('placedAt') as Timestamp;
    json['placedAt'] = ts.toDate().toIso8601String();
    return OrderModel.fromJson(json);
  }
}
