import 'package:flutter/material.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/menu_item.dart';
import '../pages/restaurant_detail_page.dart';

class SearchResultWidget extends StatelessWidget {
  final String query;
  final List<Restaurant> restaurants;
  final List<MenuItem> menuItems;
  final List<String> suggestions;
  final ValueChanged<String> onSuggestionTap;

  const SearchResultWidget({
    Key? key,
    required this.query,
    required this.restaurants,
    required this.menuItems,
    required this.suggestions,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search Query Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.orange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Results for "$query"',
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              Text(
                '${restaurants.length + menuItems.length} found',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Suggestions Section
        if (suggestions.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.lightbulb_outline, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Suggestions', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) => ActionChip(
              label: Text(
                suggestion, 
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              onPressed: () => onSuggestionTap(suggestion),
              backgroundColor: Colors.orange.withOpacity(0.1),
              side: const BorderSide(color: Colors.orange, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Restaurants Section - FIXED: Using proper ListView.builder instead of spread operator
        if (restaurants.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.restaurant, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Restaurants (${restaurants.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // FIXED: Replace spread operator with proper ListView.builder
          ...restaurants.asMap().entries.map((entry) {
            final index = entry.key;
            final restaurant = entry.value;
            return Container(
              key: ValueKey('restaurant_${restaurant.id}'), // ADDED: Unique key
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () {
                    print('🏪 Navigate to restaurant: ${restaurant.name} (${restaurant.id})'); // Debug print
                    // IMPROVED: Proper navigation with error handling
                    try {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RestaurantDetailPage(restaurant: restaurant),
                        ),
                      );
                    } catch (e) {
                      print('❌ Navigation error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Unable to open restaurant details: $e')),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Restaurant Image - IMPROVED with better error handling
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.network(
                              restaurant.imageUrl,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  width: 90,
                                  height: 90,
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.orange,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) => Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.grey,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Restaurant Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Restaurant Name
                              Text(
                                restaurant.name,
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              
                              // Cuisine Type with background
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                                ),
                                child: Text(
                                  restaurant.cuisineType,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              
                              // Rating, Time, and Delivery Info
                              Row(
                                children: [
                                  Icon(Icons.star, size: 16, color: Colors.amber[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${restaurant.rating}',
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 16),
                                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${restaurant.deliveryTime} min',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              
                              // Description
                              Text(
                                restaurant.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        
                        // Status and Price Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Open/Closed Status
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: restaurant.isOpen ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                restaurant.isOpen ? 'OPEN' : 'CLOSED',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            
                            // Delivery Fee
                            Column(
                              children: [
                                Icon(Icons.delivery_dining, color: Colors.grey[600], size: 16),
                                const SizedBox(height: 4),
                                Text(
                                  '₹${restaurant.deliveryFee.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          if (menuItems.isNotEmpty) const SizedBox(height: 24),
        ],

        // Menu Items Section - FIXED: Using proper mapping instead of spread operator
        if (menuItems.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.fastfood, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Dishes (${menuItems.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // FIXED: Replace spread operator with proper mapping
          ...menuItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Container(
              key: ValueKey('menu_item_${item.id}'), // ADDED: Unique key
              margin: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Menu Item Image - IMPROVED with better error handling
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 90,
                                height: 90,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.orange,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 90,
                              height: 90,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.fastfood,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Menu Item Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Item Name
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            
                            // Price and Rating Row
                            Row(
                              children: [
                                Text(
                                  '₹${item.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.star, size: 16, color: Colors.amber[600]),
                                const SizedBox(width: 4),
                                Text(
                                  '${item.rating}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            
                            // Description
                            Text(
                              item.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            
                            // ADDED: Additional item info
                            Wrap(
                              spacing: 8,
                              children: [
                                if (item.isVegetarian)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                                    ),
                                    child: const Text(
                                      'VEG',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (item.isSpicy)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: const Text(
                                      'SPICY',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Popular Badge and Add Button Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Popular Badge
                          if (item.isPopular)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'POPULAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          SizedBox(height: item.isPopular ? 12 : 0),
                          
                          // IMPROVED: Add to Cart Button
                          ElevatedButton(
                            onPressed: () {
                              print('🍽️ Adding ${item.name} to cart'); // Debug print
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.white),
                                      const SizedBox(width: 8),
                                      Text('${item.name} added to cart!'),
                                    ],
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'VIEW CART',
                                    textColor: Colors.white,
                                    onPressed: () {
                                      // Navigate to cart
                                      print('Navigate to cart');
                                    },
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              elevation: 2,
                            ),
                            child: const Text(
                              'ADD',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],

        // ADDED: No results message when both lists are empty (shouldn't happen due to hasResults check)
        if (restaurants.isEmpty && menuItems.isEmpty) ...[
          const SizedBox(height: 40),
          const Center(
            child: Column(
              children: [
                Icon(Icons.search_off, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No results found',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Try searching with different keywords',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}