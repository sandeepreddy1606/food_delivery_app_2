import '../entities/menu_item.dart';
import '../entities/menu_category.dart';

abstract class MenuRepository {
  Future<List<MenuCategory>> getMenuCategories(String restaurantId);
  Future<List<MenuItem>> getMenuItems(String restaurantId);
  Future<List<MenuItem>> getMenuItemsByCategory(String restaurantId, String categoryId);
  Future<MenuItem> getMenuItemById(String itemId);
  Future<List<MenuItem>> searchMenuItems(String restaurantId, String query);
}
