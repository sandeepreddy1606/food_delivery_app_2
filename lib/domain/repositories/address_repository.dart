import '../entities/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAddresses();
  Future<Address?> getCurrentAddress();
  Future<void> saveAddress(Address address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String addressId);
  Future<Address?> getCurrentLocation();
}
