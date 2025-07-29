import 'package:dio/dio.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final Dio dio;

  RestaurantRepositoryImpl(this.dio);

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      // Simulate API call delay for realistic behavior
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API call
      return [
        Restaurant(
          id: '1',
          name: 'Burger Palace',
          description: 'Delicious gourmet burgers made with fresh ingredients and served with crispy fries',
          imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
          rating: 4.7,
          cuisineType: 'American',
          deliveryTime: 30,
          deliveryFee: 2.99,
          isOpen: true,
        ),
        Restaurant(
          id: '2',
          name: 'Sushi Haven',
          description: 'Authentic Japanese sushi and sashimi prepared by expert chefs with fresh fish',
          imageUrl: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
          rating: 4.9,
          cuisineType: 'Japanese',
          deliveryTime: 45,
          deliveryFee: 3.49,
          isOpen: true,
        ),
        Restaurant(
          id: '3',
          name: 'Pizza Corner',
          description: 'Wood-fired Italian pizzas with authentic toppings and homemade dough',
          imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
          rating: 4.5,
          cuisineType: 'Italian',
          deliveryTime: 25,
          deliveryFee: 1.99,
          isOpen: true,
        ),
        Restaurant(
          id: '4',
          name: 'Taco Fiesta',
          description: 'Authentic Mexican street tacos with fresh salsa and handmade tortillas',
          imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
          rating: 4.6,
          cuisineType: 'Mexican',
          deliveryTime: 20,
          deliveryFee: 2.49,
          isOpen: true,
        ),
        Restaurant(
          id: '5',
          name: 'Curry House',
          description: 'Traditional Indian curries and freshly baked naan bread with aromatic spices',
          imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop',
          rating: 4.8,
          cuisineType: 'Indian',
          deliveryTime: 35,
          deliveryFee: 2.99,
          isOpen: true,
        ),
        Restaurant(
          id: '6',
          name: 'Dragon Wok',
          description: 'Fresh Chinese stir-fry dishes and dim sum made with traditional recipes',
          imageUrl: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400&h=300&fit=crop',
          rating: 4.4,
          cuisineType: 'Chinese',
          deliveryTime: 30,
          deliveryFee: 2.99,
          isOpen: false,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch restaurants: $e');
    }
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.firstWhere(
        (restaurant) => restaurant.id == id,
        orElse: () => throw Exception('Restaurant not found'),
      );
    } catch (e) {
      throw Exception('Failed to fetch restaurant: $e');
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.where((restaurant) =>
        restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
        restaurant.cuisineType.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.where((restaurant) =>
        restaurant.cuisineType.toLowerCase() == category.toLowerCase()
      ).toList();
    } catch (e) {
      throw Exception('Failed to fetch restaurants by category: $e');
    }
  }
}
