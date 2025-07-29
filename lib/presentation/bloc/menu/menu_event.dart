part of 'menu_bloc.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class FetchMenuData extends MenuEvent {
  final String restaurantId;

  const FetchMenuData(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}

class SelectMenuCategory extends MenuEvent {
  final String categoryId;

  const SelectMenuCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

class SearchMenuItems extends MenuEvent {
  final String query;

  const SearchMenuItems(this.query);

  @override
  List<Object> get props => [query];
}
