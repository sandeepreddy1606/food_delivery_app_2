import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/repositories/address_repository.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressRepository addressRepository;

  AddressBloc({required this.addressRepository}) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<SelectAddress>(_onSelectAddress);
    on<AddNewAddress>(_onAddNewAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
    on<GetCurrentLocation>(_onGetCurrentLocation);
  }

  Future<void> _onLoadAddresses(
    LoadAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final addresses = await addressRepository.getAddresses();
      final currentAddress = await addressRepository.getCurrentAddress();
      
      emit(AddressLoaded(
        addresses: addresses,
        selectedAddress: currentAddress,
      ));
    } catch (error) {
      emit(AddressError('Failed to load addresses: $error'));
    }
  }

  Future<void> _onSelectAddress(
    SelectAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      if (state is AddressLoaded) {
        final currentState = state as AddressLoaded;
        
        // If it's not current location, save as current address
        if (!event.address.isCurrentLocation) {
          await addressRepository.setDefaultAddress(event.address.id);
        }
        
        emit(currentState.copyWith(selectedAddress: event.address));
      }
    } catch (error) {
      emit(AddressError('Failed to select address: $error'));
    }
  }

  Future<void> _onAddNewAddress(
    AddNewAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await addressRepository.saveAddress(event.address);
      emit(const AddressOperationSuccess('Address added successfully'));
      
      // Reload addresses
      add(LoadAddresses());
    } catch (error) {
      emit(AddressError('Failed to add address: $error'));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      await addressRepository.saveAddress(event.address);
      emit(const AddressOperationSuccess('Address updated successfully'));
      
      // Reload addresses
      add(LoadAddresses());
    } catch (error) {
      emit(AddressError('Failed to update address: $error'));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      await addressRepository.deleteAddress(event.addressId);
      emit(const AddressOperationSuccess('Address deleted successfully'));
      
      // Reload addresses
      add(LoadAddresses());
    } catch (error) {
      emit(AddressError('Failed to delete address: $error'));
    }
  }

  Future<void> _onSetDefaultAddress(
    SetDefaultAddress event,
    Emitter<AddressState> emit,
  ) async {
    try {
      await addressRepository.setDefaultAddress(event.addressId);
      
      // Reload addresses
      add(LoadAddresses());
    } catch (error) {
      emit(AddressError('Failed to set default address: $error'));
    }
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocation event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoading());
    try {
      final currentLocation = await addressRepository.getCurrentLocation();
      if (currentLocation != null) {
        if (state is AddressLoaded) {
          final currentState = state as AddressLoaded;
          emit(currentState.copyWith(selectedAddress: currentLocation));
        }
      } else {
        emit(const AddressError('Unable to get current location'));
      }
    } catch (error) {
      emit(AddressError('Failed to get current location: $error'));
    }
  }
}
