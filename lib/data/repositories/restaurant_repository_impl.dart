import 'package:dio/dio.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final Dio dio;

  RestaurantRepositoryImpl(this.dio);

  @override
  Future<List<Restaurant>> getRestaurants() async {
    try {
      print('📊 Loading all restaurants...'); // ADDED: Debug print
      // Simulate API call delay for realistic behavior
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock data - replace with actual API call
      final restaurants = [
        Restaurant(
          id: '1',
          name: 'Burger Palace',
          description:
              'Delicious gourmet burgers made with fresh ingredients and served with crispy fries',
          imageUrl:
              'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop',
          rating: 4.7,
          cuisineType: 'American',
          deliveryTime: 30,
          deliveryFee: 2.99,
          isOpen: true,
        ),
        Restaurant(
          id: '2',
          name: 'Sushi Haven',
          description:
              'Authentic Japanese sushi and sashimi prepared by expert chefs with fresh fish',
          imageUrl:
              'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=400&h=300&fit=crop',
          rating: 4.9,
          cuisineType: 'Japanese',
          deliveryTime: 45,
          deliveryFee: 3.49,
          isOpen: true,
        ),
        Restaurant(
          id: '3',
          name: 'Pizza Corner',
          description:
              'Wood-fired Italian pizzas with authentic toppings and homemade dough',
          imageUrl:
              'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
          rating: 4.5,
          cuisineType: 'Italian',
          deliveryTime: 25,
          deliveryFee: 1.99,
          isOpen: true,
        ),
        Restaurant(
          id: '4',
          name: 'Taco Fiesta',
          description:
              'Authentic Mexican street tacos with fresh salsa and handmade tortillas',
          imageUrl:
              'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
          rating: 4.6,
          cuisineType: 'Mexican',
          deliveryTime: 20,
          deliveryFee: 2.49,
          isOpen: true,
        ),
        Restaurant(
          id: '5',
          name: 'Curry House',
          description:
              'Traditional Indian curries and freshly baked naan bread with aromatic spices',
          imageUrl:
              'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=300&fit=crop',
          rating: 4.8,
          cuisineType: 'Indian',
          deliveryTime: 35,
          deliveryFee: 2.99,
          isOpen: true,
        ),
        Restaurant(
          id: '6',
          name: 'Dragon Wok',
          description:
              'Fresh Chinese stir-fry dishes and dim sum made with traditional recipes',
          imageUrl:
              'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400&h=300&fit=crop',
          rating: 4.4,
          cuisineType: 'Chinese',
          deliveryTime: 30,
          deliveryFee: 2.99,
          isOpen: false,
        ),
      ];
      
      print('📊 Loaded ${restaurants.length} restaurants successfully'); // ADDED: Debug print
      return restaurants;
    } catch (e) {
      print('❌ Error loading restaurants: $e'); // ADDED: Debug print
      throw Exception('Failed to fetch restaurants: $e');
    }
  }

  @override
  Future<Restaurant> getRestaurantById(String id) async {
    try {
      print('📊 Loading restaurant with ID: $id'); // ADDED: Debug print
      final restaurants = await getRestaurants();
      final restaurant = restaurants.firstWhere(
        (restaurant) => restaurant.id == id,
        orElse: () => throw Exception('Restaurant not found'),
      );
      print('📊 Found restaurant: ${restaurant.name}'); // ADDED: Debug print
      return restaurant;
    } catch (e) {
      print('❌ Error loading restaurant by ID: $e'); // ADDED: Debug print
      throw Exception('Failed to fetch restaurant: $e');
    }
  }

  @override
  Future<List<Restaurant>> searchRestaurants(String query) async {
    try {
      print('🔍 Searching restaurants for query: "$query"'); // ADDED: Debug print
      final restaurants = await getRestaurants();
      
      // IMPROVED: More comprehensive search logic
      final searchQuery = query.toLowerCase().trim();
      final results = restaurants.where((restaurant) {
        final name = restaurant.name.toLowerCase();
        final cuisineType = restaurant.cuisineType.toLowerCase();
        final description = restaurant.description.toLowerCase();
        
        return name.contains(searchQuery) || 
               cuisineType.contains(searchQuery) ||
               description.contains(searchQuery);
      }).toList();
      
      // ADDED: Sort results by relevance (exact matches first, then partial matches)
      results.sort((a, b) {
        final aName = a.name.toLowerCase();
        final bName = b.name.toLowerCase();
        final aCuisine = a.cuisineType.toLowerCase();
        final bCuisine = b.cuisineType.toLowerCase();
        
        // Exact name matches first
        if (aName.startsWith(searchQuery) && !bName.startsWith(searchQuery)) return -1;
        if (!aName.startsWith(searchQuery) && bName.startsWith(searchQuery)) return 1;
        
        // Exact cuisine matches second
        if (aCuisine == searchQuery && bCuisine != searchQuery) return -1;
        if (aCuisine != searchQuery && bCuisine == searchQuery) return 1;
        
        // Then by rating (highest first)
        return b.rating.compareTo(a.rating);
      });
      
      print('🔍 Found ${results.length} matching restaurants:'); // ADDED: Debug print
      for (final restaurant in results) {
        print('  - ${restaurant.name} (${restaurant.cuisineType})'); // ADDED: Debug print
      }
      
      return results;
    } catch (e) {
      print('❌ Error searching restaurants: $e'); // ADDED: Debug print
      throw Exception('Failed to search restaurants: $e');
    }
  }

  @override
  Future<List<Restaurant>> getRestaurantsByCategory(String category) async {
    try {
      print('🏷️ Loading restaurants by category: "$category"'); // ADDED: Debug print
      final restaurants = await getRestaurants();
      
      // IMPROVED: Handle 'All' category and case-insensitive matching
      if (category.toLowerCase() == 'all') {
        print('🏷️ Returning all ${restaurants.length} restaurants'); // ADDED: Debug print
        return restaurants;
      }
      
      final results = restaurants.where((restaurant) =>
          restaurant.cuisineType.toLowerCase() == category.toLowerCase()).toList();
      
      // ADDED: Sort by rating (highest first) and then by delivery time (fastest first)
      results.sort((a, b) {
        final ratingComparison = b.rating.compareTo(a.rating);
        if (ratingComparison != 0) return ratingComparison;
        return a.deliveryTime.compareTo(b.deliveryTime);
      });
      
      print('🏷️ Found ${results.length} restaurants in "$category" category:'); // ADDED: Debug print
      for (final restaurant in results) {
        print('  - ${restaurant.name} (Rating: ${restaurant.rating}, Time: ${restaurant.deliveryTime}min)'); // ADDED: Debug print
      }
      
      return results;
    } catch (e) {
      print('❌ Error loading restaurants by category: $e'); // ADDED: Debug print
      throw Exception('Failed to fetch restaurants by category: $e');
    }
  }

  // ADDED: New method for getting open restaurants only
  Future<List<Restaurant>> getOpenRestaurants() async {
    try {
      print('🕒 Loading open restaurants only...'); // Debug print
      final restaurants = await getRestaurants();
      final openRestaurants = restaurants.where((restaurant) => restaurant.isOpen).toList();
      
      // Sort by rating
      openRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
      
      print('🕒 Found ${openRestaurants.length} open restaurants'); // Debug print
      return openRestaurants;
    } catch (e) {
      print('❌ Error loading open restaurants: $e'); // Debug print
      throw Exception('Failed to fetch open restaurants: $e');
    }
  }

  // ADDED: New method for getting restaurants by delivery time
  Future<List<Restaurant>> getRestaurantsByDeliveryTime(int maxDeliveryTime) async {
    try {
      print('⏱️ Loading restaurants with delivery time <= ${maxDeliveryTime}min...'); // Debug print
      final restaurants = await getRestaurants();
      final fastDeliveryRestaurants = restaurants
          .where((restaurant) => restaurant.deliveryTime <= maxDeliveryTime)
          .toList();
      
      // Sort by delivery time (fastest first)
      fastDeliveryRestaurants.sort((a, b) => a.deliveryTime.compareTo(b.deliveryTime));
      
      print('⏱️ Found ${fastDeliveryRestaurants.length} restaurants with fast delivery'); // Debug print
      return fastDeliveryRestaurants;
    } catch (e) {
      print('❌ Error loading restaurants by delivery time: $e'); // Debug print
      throw Exception('Failed to fetch restaurants by delivery time: $e');
    }
  }

  // ADDED: New method for getting restaurants by rating
  Future<List<Restaurant>> getHighRatedRestaurants(double minRating) async {
    try {
      print('⭐ Loading restaurants with rating >= $minRating...'); // Debug print
      final restaurants = await getRestaurants();
      final highRatedRestaurants = restaurants
          .where((restaurant) => restaurant.rating >= minRating)
          .toList();
      
      // Sort by rating (highest first)
      highRatedRestaurants.sort((a, b) => b.rating.compareTo(a.rating));
      
      print('⭐ Found ${highRatedRestaurants.length} high-rated restaurants'); // Debug print
      return highRatedRestaurants;
    } catch (e) {
      print('❌ Error loading high-rated restaurants: $e'); // Debug print
      throw Exception('Failed to fetch high-rated restaurants: $e');
    }
  }
}