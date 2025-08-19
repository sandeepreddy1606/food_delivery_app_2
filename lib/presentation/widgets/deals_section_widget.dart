import 'package:flutter/material.dart';

class DealsSectionWidget extends StatelessWidget {
  const DealsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deals = [
      {'title': 'Buy 1 Get 1', 'subtitle': 'On all pizzas', 'discount': '50%', 'color': Colors.red},
      {'title': 'Free Delivery', 'subtitle': 'Orders above ₹199', 'discount': 'FREE', 'color': Colors.green},
      {'title': 'Happy Hours', 'subtitle': '3-6 PM daily', 'discount': '30%', 'color': Colors.purple},
      {'title': 'Weekend Special', 'subtitle': 'Sat & Sun only', 'discount': '40%', 'color': Colors.blue},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deals of the Day",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(), // Fixed scrolling
              padding: const EdgeInsets.symmetric(horizontal: 8), // Added padding
              itemCount: deals.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final deal = deals[index];
                return Container(
                  width: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (deal['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: (deal['color'] as Color).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              deal['title'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: deal['color'] as Color,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              deal['subtitle'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: deal['color'] as Color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          deal['discount'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
