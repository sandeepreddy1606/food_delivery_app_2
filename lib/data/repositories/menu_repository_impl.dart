import 'package:dio/dio.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/menu_category.dart';
import '../../domain/repositories/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  final Dio dio;

  MenuRepositoryImpl(this.dio);

  @override
  Future<List<MenuCategory>> getMenuCategories(String restaurantId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        MenuCategory(
          id: '1',
          name: 'Appetizers',
          description: 'Start your meal with these delicious appetizers',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046747.png',
          sortOrder: 1,
          isActive: true,
        ),
        MenuCategory(
          id: '2',
          name: 'Main Courses',
          description: 'Hearty main dishes to satisfy your hunger',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
          sortOrder: 2,
          isActive: true,
        ),
        MenuCategory(
          id: '3',
          name: 'Desserts',
          description: 'Sweet treats to end your meal perfectly',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046729.png',
          sortOrder: 3,
          isActive: true,
        ),
        MenuCategory(
          id: '4',
          name: 'Beverages',
          description: 'Refreshing drinks and hot beverages',
          iconUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046751.png',
          sortOrder: 4,
          isActive: true,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch menu categories: $e');
    }
  }

  @override
  Future<List<MenuItem>> getMenuItems(String restaurantId) async {
    try {
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        // Appetizers
        MenuItem(
          id: '1',
          name: 'Buffalo Wings',
          description: 'Crispy chicken wings tossed in spicy buffalo sauce, served with celery sticks and blue cheese dip',
          price: 12.99,
          imageUrl: 'https://images.unsplash.com/photo-1608039755401-742074f0548d?w=400&h=300&fit=crop',
          categoryId: '1',
          ingredients: ['Chicken wings', 'Buffalo sauce', 'Celery', 'Blue cheese'],
          isVegetarian: false,
          isSpicy: true,
          preparationTime: 15,
          rating: 4.6,
          calories: 320,
          isPopular: true,
          isAvailable: true,
        ),
        MenuItem(
          id: '2',
          name: 'Mozzarella Sticks',
          description: 'Golden fried mozzarella cheese sticks served with marinara sauce',
          price: 9.99,
          imageUrl: 'https://images.unsplash.com/photo-1531749668029-2db88e4276c7?w=400&h=300&fit=crop',
          categoryId: '1',
          ingredients: ['Mozzarella cheese', 'Breadcrumbs', 'Marinara sauce'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 12,
          rating: 4.4,
          calories: 280,
          isPopular: false,
          isAvailable: true,
        ),
        
        // Main Courses
        MenuItem(
          id: '3',
          name: 'Grilled Salmon',
          description: 'Fresh Atlantic salmon grilled to perfection, served with roasted vegetables and lemon butter sauce',
          price: 24.99,
          imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=300&fit=crop',
          categoryId: '2',
          ingredients: ['Atlantic salmon', 'Mixed vegetables', 'Lemon', 'Butter', 'Herbs'],
          isVegetarian: false,
          isSpicy: false,
          preparationTime: 25,
          rating: 4.8,
          calories: 450,
          isPopular: true,
          isAvailable: true,
        ),
        MenuItem(
          id: '4',
          name: 'Margherita Pizza',
          description: 'Classic Italian pizza with fresh tomatoes, mozzarella cheese, and basil on a crispy thin crust',
          price: 16.99,
          imageUrl: 'https://images.unsplash.com/photo-1604382354936-07c5d9983bd3?w=400&h=300&fit=crop',
          categoryId: '2',
          ingredients: ['Pizza dough', 'Tomato sauce', 'Mozzarella', 'Fresh basil', 'Olive oil'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 18,
          rating: 4.7,
          calories: 380,
          isPopular: true,
          isAvailable: true,
        ),
        MenuItem(
          id: '9',
          name: 'Chicken Alfredo Pasta',
          description: 'Tender grilled chicken breast served over creamy fettuccine alfredo with parmesan cheese',
          price: 18.99,
          imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d946?w=400&h=300&fit=crop',
          categoryId: '2',
          ingredients: ['Fettuccine pasta', 'Chicken breast', 'Alfredo sauce', 'Parmesan cheese', 'Garlic'],
          isVegetarian: false,
          isSpicy: false,
          preparationTime: 20,
          rating: 4.5,
          calories: 520,
          isPopular: false,
          isAvailable: true,
        ),
        
        // Desserts
        MenuItem(
          id: '5',
          name: 'Chocolate Brownie',
          description: 'Warm, fudgy chocolate brownie served with vanilla ice cream and chocolate sauce',
          price: 8.99,
          imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=300&fit=crop',
          categoryId: '3',
          ingredients: ['Dark chocolate', 'Butter', 'Eggs', 'Sugar', 'Vanilla ice cream'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 10,
          rating: 4.5,
          calories: 420,
          isPopular: false,
          isAvailable: true,
        ),
        MenuItem(
          id: '6',
          name: 'Tiramisu',
          description: 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream',
          price: 10.99,
          imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=300&fit=crop',
          categoryId: '3',
          ingredients: ['Ladyfingers', 'Espresso', 'Mascarpone', 'Cocoa powder', 'Sugar'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 5,
          rating: 4.9,
          calories: 350,
          isPopular: true,
          isAvailable: true,
        ),
        
        // Beverages
        MenuItem(
          id: '7',
          name: 'Fresh Orange Juice',
          description: 'Freshly squeezed orange juice, rich in vitamin C and natural sweetness',
          price: 4.99,
          imageUrl: 'https://images.unsplash.com/photo-1613478223719-2ab802602423?w=400&h=300&fit=crop',
          categoryId: '4',
          ingredients: ['Fresh oranges'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 3,
          rating: 4.3,
          calories: 110,
          isPopular: false,
          isAvailable: true,
        ),
        MenuItem(
          id: '8',
          name: 'Iced Coffee',
          description: 'Smooth cold brew coffee served over ice with your choice of milk and sweetener',
          price: 5.99,
          imageUrl: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=400&h=300&fit=crop',
          categoryId: '4',
          ingredients: ['Coffee beans', 'Ice', 'Milk', 'Sugar'],
          isVegetarian: true,
          isSpicy: false,
          preparationTime: 5,
          rating: 4.4,
          calories: 95,
          isPopular: true,
          isAvailable: true,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch menu items: $e');
    }
  }

  @override
  Future<List<MenuItem>> getMenuItemsByCategory(String restaurantId, String categoryId) async {
    try {
      final allItems = await getMenuItems(restaurantId);
      return allItems.where((item) => item.categoryId == categoryId).toList();
    } catch (e) {
      throw Exception('Failed to fetch menu items by category: $e');
    }
  }

  @override
  Future<MenuItem> getMenuItemById(String itemId) async {
    try {
      final allItems = await getMenuItems('');
      return allItems.firstWhere(
        (item) => item.id == itemId,
        orElse: () => throw Exception('Menu item not found'),
      );
    } catch (e) {
      throw Exception('Failed to fetch menu item: $e');
    }
  }

  @override
  Future<List<MenuItem>> searchMenuItems(String restaurantId, String query) async {
    try {
      final allItems = await getMenuItems(restaurantId);
      return allItems.where((item) =>
        item.name.toLowerCase().contains(query.toLowerCase()) ||
        item.description.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      throw Exception('Failed to search menu items: $e');
    }
  }
}
