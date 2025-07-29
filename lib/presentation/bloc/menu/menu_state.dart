part of 'menu_bloc.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuCategory> categories;
  final List<MenuItem> menuItems;
  final List<MenuItem> filteredItems;
  final String? selectedCategoryId;
  final String searchQuery;
  final bool isSearching;

  const MenuLoaded({
    required this.categories,
    required this.menuItems,
    required this.filteredItems,
    this.selectedCategoryId,
    this.searchQuery = '',
    this.isSearching = false,
  });

  MenuLoaded copyWith({
    List<MenuCategory>? categories,
    List<MenuItem>? menuItems,
    List<MenuItem>? filteredItems,
    String? selectedCategoryId,
    String? searchQuery,
    bool? isSearching,
  }) {
    return MenuLoaded(
      categories: categories ?? this.categories,
      menuItems: menuItems ?? this.menuItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object> get props => [
        categories,
        menuItems,
        filteredItems,
        selectedCategoryId ?? '',
        searchQuery,
        isSearching,
      ];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object> get props => [message];
}
