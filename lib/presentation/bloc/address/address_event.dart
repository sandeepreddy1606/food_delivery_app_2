import 'package:equatable/equatable.dart';
import '../../../domain/entities/address.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class LoadAddresses extends AddressEvent {}

class SelectAddress extends AddressEvent {
  final Address address;
  
  const SelectAddress(this.address);
  
  @override
  List<Object?> get props => [address];
}

class AddNewAddress extends AddressEvent {
  final Address address;
  
  const AddNewAddress(this.address);
  
  @override
  List<Object?> get props => [address];
}

class UpdateAddress extends AddressEvent {
  final Address address;
  
  const UpdateAddress(this.address);
  
  @override
  List<Object?> get props => [address];
}

class DeleteAddress extends AddressEvent {
  final String addressId;
  
  const DeleteAddress(this.addressId);
  
  @override
  List<Object?> get props => [addressId];
}

class SetDefaultAddress extends AddressEvent {
  final String addressId;
  
  const SetDefaultAddress(this.addressId);
  
  @override
  List<Object?> get props => [addressId];
}

class GetCurrentLocation extends AddressEvent {}
