import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<List<Restaurant>> getRestaurants();
  Future<Restaurant> getRestaurantById(String id);
  Future<List<Restaurant>> searchRestaurants(String query);
  Future<List<Restaurant>> getRestaurantsByCategory(String category);
}
