import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/restaurant.dart';
import '../../../domain/repositories/restaurant_repository.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository repository;

  RestaurantBloc({required this.repository}) : super(RestaurantInitial()) {
    on<FetchRestaurants>(_onFetchRestaurants);
    on<SelectRestaurant>(_onSelectRestaurant);
    on<SearchRestaurants>(_onSearchRestaurants);
    on<FilterRestaurantsByCategory>(_onFilterRestaurantsByCategory);
    on<RefreshRestaurants>(_onRefreshRestaurants);
  }

  Future<void> _onFetchRestaurants(
    FetchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    try {
      final restaurants = await repository.getRestaurants();
      emit(RestaurantLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantError('Failed to load restaurants. Please try again.'));
    }
  }

  Future<void> _onSelectRestaurant(
    SelectRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      try {
        final restaurant = await repository.getRestaurantById(event.restaurantId);
        emit(currentState.copyWith(selectedRestaurant: restaurant));
      } catch (e) {
        emit(RestaurantError('Failed to load restaurant details. Please try again.'));
      }
    }
  }

  Future<void> _onSearchRestaurants(
    SearchRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      if (event.query.isEmpty) {
        try {
          final restaurants = await repository.getRestaurants();
          emit(currentState.copyWith(
            restaurants: restaurants,
            isSearching: false,
            searchQuery: '',
          ));
        } catch (e) {
          emit(RestaurantError('Failed to load restaurants. Please try again.'));
        }
      } else {
        try {
          final restaurants = await repository.searchRestaurants(event.query);
          emit(currentState.copyWith(
            restaurants: restaurants,
            isSearching: true,
            searchQuery: event.query,
          ));
        } catch (e) {
          emit(RestaurantError('Failed to search restaurants. Please try again.'));
        }
      }
    }
  }

  Future<void> _onFilterRestaurantsByCategory(
    FilterRestaurantsByCategory event,
    Emitter<RestaurantState> emit,
  ) async {
    final currentState = state;
    if (currentState is RestaurantLoaded) {
      try {
        final restaurants = await repository.getRestaurantsByCategory(event.category);
        emit(currentState.copyWith(
          restaurants: restaurants,
          selectedCategory: event.category,
        ));
      } catch (e) {
        emit(RestaurantError('Failed to filter restaurants. Please try again.'));
      }
    }
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    try {
      final restaurants = await repository.getRestaurants();
      emit(RestaurantLoaded(restaurants: restaurants));
    } catch (e) {
      emit(RestaurantError('Failed to refresh restaurants. Please try again.'));
    }
  }
}
