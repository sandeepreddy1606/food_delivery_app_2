class Restaurant {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String cuisineType;
  final int deliveryTime;
  final double deliveryFee;
  final bool isOpen;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.cuisineType,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.isOpen,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Restaurant && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Restaurant(id: $id, name: $name, rating: $rating)';
  }
}
