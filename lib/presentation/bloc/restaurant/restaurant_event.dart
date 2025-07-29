part of 'restaurant_bloc.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class FetchRestaurants extends RestaurantEvent {}

class SelectRestaurant extends RestaurantEvent {
  final String restaurantId;

  const SelectRestaurant(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class SearchRestaurants extends RestaurantEvent {
  final String query;

  const SearchRestaurants(this.query);

  @override
  List<Object> get props => [query];
}

class FilterRestaurantsByCategory extends RestaurantEvent {
  final String category;

  const FilterRestaurantsByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class RefreshRestaurants extends RestaurantEvent {}
