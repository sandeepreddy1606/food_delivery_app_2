import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final SharedPreferences prefs;
  static const String _addressesKey = 'saved_addresses';
  static const String _currentAddressKey = 'current_address';

  AddressRepositoryImpl(this.prefs);

  @override
  Future<List<Address>> getAddresses() async {
    try {
      final addressesJson = prefs.getStringList(_addressesKey) ?? [];
      final addresses = addressesJson
          .map((json) => Address.fromJson(jsonDecode(json)))
          .toList();
      
      // Add current location if available
      final currentLocation = await getCurrentLocation();
      if (currentLocation != null) {
        addresses.insert(0, currentLocation);
      }
      
      return addresses;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to load addresses: $e');
      }
      return [];
    }
  }

  @override
  Future<Address?> getCurrentAddress() async {
    try {
      final currentAddressJson = prefs.getString(_currentAddressKey);
      if (currentAddressJson != null) {
        return Address.fromJson(jsonDecode(currentAddressJson));
      }
      
      // If no saved current address, try to get current location
      return await getCurrentLocation();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current address: $e');
      }
      return null;
    }
  }

  @override
  Future<void> saveAddress(Address address) async {
    try {
      final addresses = await getAddresses();
      
      // Remove current location from the list for saving
      final savedAddresses = addresses.where((a) => !a.isCurrentLocation).toList();
      
      // Add or update the address
      final existingIndex = savedAddresses.indexWhere((a) => a.id == address.id);
      if (existingIndex >= 0) {
        savedAddresses[existingIndex] = address;
      } else {
        savedAddresses.add(address);
      }

      // If this is set as default, remove default from others
      if (address.isDefault) {
        for (int i = 0; i < savedAddresses.length; i++) {
          if (savedAddresses[i].id != address.id) {
            savedAddresses[i] = savedAddresses[i].copyWith(isDefault: false);
          }
        }
      }

      final addressesJson = savedAddresses
          .map((address) => jsonEncode(address.toJson()))
          .toList();
      
      await prefs.setStringList(_addressesKey, addressesJson);
    } catch (e) {
      throw Exception('Failed to save address: $e');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      final addresses = await getAddresses();
      final filteredAddresses = addresses
          .where((a) => a.id != addressId && !a.isCurrentLocation)
          .toList();

      final addressesJson = filteredAddresses
          .map((address) => jsonEncode(address.toJson()))
          .toList();
      
      await prefs.setStringList(_addressesKey, addressesJson);
    } catch (e) {
      throw Exception('Failed to delete address: $e');
    }
  }

  @override
  Future<void> setDefaultAddress(String addressId) async {
    try {
      final addresses = await getAddresses();
      final updatedAddresses = addresses.where((a) => !a.isCurrentLocation).map((address) {
        return address.copyWith(isDefault: address.id == addressId);
      }).toList();

      final addressesJson = updatedAddresses
          .map((address) => jsonEncode(address.toJson()))
          .toList();
      
      await prefs.setStringList(_addressesKey, addressesJson);
      
      // Also save as current address
      final defaultAddress = updatedAddresses.firstWhere((a) => a.id == addressId);
      await prefs.setString(_currentAddressKey, jsonEncode(defaultAddress.toJson()));
    } catch (e) {
      throw Exception('Failed to set default address: $e');
    }
  }

  @override
  Future<Address?> getCurrentLocation() async {
    try {
      // Check location service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (kDebugMode) {
          print('Location services are disabled.');
        }
        return null;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (kDebugMode) {
            print('Location permissions are denied');
          }
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (kDebugMode) {
          print('Location permissions are permanently denied');
        }
        return null;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Get address from coordinates
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return Address(
          id: 'current_location',
          label: 'Current Location',
          addressLine1: '${placemark.name ?? ''} ${placemark.street ?? ''}',
          addressLine2: placemark.subLocality ?? '',
          city: placemark.locality ?? '',
          state: placemark.administrativeArea ?? '',
          pincode: placemark.postalCode ?? '',
          latitude: position.latitude,
          longitude: position.longitude,
          isCurrentLocation: true,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting current location: $e');
      }
    }
    return null;
  }
}
