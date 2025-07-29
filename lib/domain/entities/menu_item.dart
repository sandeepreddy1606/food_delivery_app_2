import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final bool isVegetarian;
  final bool isSpicy;
  final bool isAvailable;
  final bool isPopular;
  final double rating;
  final int calories;
  final int preparationTime;
  final List<String> ingredients;

  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.isVegetarian,
    required this.isSpicy,
    required this.isAvailable,
    required this.isPopular,
    required this.rating,
    required this.calories,
    required this.preparationTime,
    required this.ingredients,
  });

  // Add fromJson constructor for compatibility
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['categoryId'] as String,
      imageUrl: json['imageUrl'] as String,
      isVegetarian: json['isVegetarian'] as bool,
      isSpicy: json['isSpicy'] as bool,
      isAvailable: json['isAvailable'] as bool,
      isPopular: json['isPopular'] as bool,
      rating: (json['rating'] as num).toDouble(),
      calories: json['calories'] as int,
      preparationTime: json['preparationTime'] as int,
      ingredients: List<String>.from(json['ingredients'] as List),
    );
  }

  // Add toJson method for compatibility
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'imageUrl': imageUrl,
        'isVegetarian': isVegetarian,
        'isSpicy': isSpicy,
        'isAvailable': isAvailable,
        'isPopular': isPopular,
        'rating': rating,
        'calories': calories,
        'preparationTime': preparationTime,
        'ingredients': ingredients,
      };

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        imageUrl,
        isVegetarian,
        isSpicy,
        isAvailable,
        isPopular,
        rating,
        calories,
        preparationTime,
        ingredients,
      ];
}
