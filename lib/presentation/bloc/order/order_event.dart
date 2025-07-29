import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object> get props => [];  // Fixed HTML entity &gt; to proper >
}

class FetchOrders extends OrderEvent {}
