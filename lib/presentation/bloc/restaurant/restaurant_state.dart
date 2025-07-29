part of 'restaurant_bloc.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantLoaded extends RestaurantState {
  final List<Restaurant> restaurants;
  final Restaurant? selectedRestaurant;
  final bool isSearching;
  final String searchQuery;
  final String? selectedCategory;

  const RestaurantLoaded({
    required this.restaurants,
    this.selectedRestaurant,
    this.isSearching = false,
    this.searchQuery = '',
    this.selectedCategory,
  });

  RestaurantLoaded copyWith({
    List<Restaurant>? restaurants,
    Restaurant? selectedRestaurant,
    bool? isSearching,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return RestaurantLoaded(
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    restaurants,
    selectedRestaurant,
    isSearching,
    searchQuery,
    selectedCategory,
  ];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object> get props => [message];
}
