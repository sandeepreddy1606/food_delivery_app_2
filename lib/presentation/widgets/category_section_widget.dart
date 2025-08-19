import 'package:flutter/material.dart';
import '../pages/restaurant_list_page.dart';

class CategorySectionWidget extends StatelessWidget {
  const CategorySectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.fastfood, 'label': 'Burgers'},
      {'icon': Icons.local_pizza, 'label': 'Pizza'},
      {'icon': Icons.ramen_dining, 'label': 'Asian'},
      {'icon': Icons.cake, 'label': 'Dessert'},
      {'icon': Icons.local_bar, 'label': 'Drinks'},
      {'icon': Icons.icecream, 'label': 'Ice Cream'},
      {'icon': Icons.lunch_dining, 'label': 'Healthy'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's on your mind?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Fixed scrolling
              padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 20),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RestaurantListPage()));
                  },
                  child: SizedBox(
                    width: 70, // Fixed width for proper scrolling
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange.withOpacity(0.1),
                          child: Icon(categories[index]['icon'] as IconData, color: Colors.orange, size: 28),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          categories[index]['label'] as String,
                          style: const TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
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
