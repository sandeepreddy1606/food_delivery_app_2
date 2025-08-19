import 'package:flutter/material.dart';

class PopularDishesWidget extends StatelessWidget {
  const PopularDishesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock popular dishes data - replace with actual data from your backend
    final popularDishes = [
      {'name': 'Margherita Pizza', 'image': 'https://images.unsplash.com/photo-1604382355076-af4b0eb60143?w=300', 'price': 299.0, 'rating': 4.5},
      {'name': 'Burger Deluxe', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300', 'price': 199.0, 'rating': 4.2},
      {'name': 'Chicken Biryani', 'image': 'https://images.unsplash.com/photo-1563379091339-03246963d51a?w=300', 'price': 349.0, 'rating': 4.7},
      {'name': 'Pasta Alfredo', 'image': 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=300', 'price': 249.0, 'rating': 4.3},
      {'name': 'Sushi Roll', 'image': 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=300', 'price': 399.0, 'rating': 4.6},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Popular Right Now",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Fixed scrolling
              padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
              itemCount: popularDishes.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final dish = popularDishes[index];
                return Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.network(
                          dish['image'] as String,
                          height: 120,
                          width: 160,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 120,
                              width: 160,
                              color: Colors.grey[300],
                              child: const Center(child: CircularProgressIndicator()),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 120,
                            width: 160,
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dish['name'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${dish['price']}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 2),
                                Text(
                                  dish['rating'].toString(),
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
