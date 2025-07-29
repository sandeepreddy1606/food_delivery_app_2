import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  MenuItemModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String categoryId,
    required String imageUrl,
    required bool isVegetarian,
    required bool isSpicy,
    required bool isAvailable,
    required bool isPopular,
    required double rating,
    required int calories,
    required int preparationTime,
    required List<String> ingredients,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          categoryId: categoryId,
          imageUrl: imageUrl,
          isVegetarian: isVegetarian,
          isSpicy: isSpicy,
          isAvailable: isAvailable,
          isPopular: isPopular,
          rating: rating,
          calories: calories,
          preparationTime: preparationTime,
          ingredients: ingredients,
        );

  /// Convert a domain [MenuItem] into a data [MenuItemModel]
  factory MenuItemModel.fromMenuItem(MenuItem item) {
    return MenuItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      price: item.price,
      categoryId: item.categoryId,
      imageUrl: item.imageUrl,
      isVegetarian: item.isVegetarian,
      isSpicy: item.isSpicy,
      isAvailable: item.isAvailable,
      isPopular: item.isPopular,
      rating: item.rating,
      calories: item.calories,
      preparationTime: item.preparationTime,
      ingredients: item.ingredients,
    );
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
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
      ingredients: List<String>.from(
        (json['ingredients'] as List<dynamic>).map((e) => e as String),
      ),
    );
  }

  @override
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
}
