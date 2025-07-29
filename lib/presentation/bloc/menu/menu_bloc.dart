import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/entities/menu_category.dart';
import '../../../domain/repositories/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository repository;

  MenuBloc({required this.repository}) : super(MenuInitial()) {
    on<FetchMenuData>(_onFetchMenuData);
    on<SelectMenuCategory>(_onSelectMenuCategory);
    on<SearchMenuItems>(_onSearchMenuItems);
  }

  Future<void> _onFetchMenuData(
    FetchMenuData event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    try {
      final categories = await repository.getMenuCategories(event.restaurantId);
      final menuItems = await repository.getMenuItems(event.restaurantId);
      emit(MenuLoaded(
        categories: categories,
        menuItems: menuItems,
        filteredItems: menuItems,
      ));
    } catch (e) {
      emit(MenuError('Failed to load menu data. Please try again.'));
    }
  }

  Future<void> _onSelectMenuCategory(
    SelectMenuCategory event,
    Emitter<MenuState> emit,
  ) async {
    final currentState = state;
    if (currentState is MenuLoaded) {
      List<MenuItem> filteredItems;
      if (event.categoryId == 'all') {
        filteredItems = currentState.menuItems;
      } else {
        filteredItems = currentState.menuItems
            .where((item) => item.categoryId == event.categoryId)
            .toList();
      }

      emit(currentState.copyWith(
        selectedCategoryId: event.categoryId,
        filteredItems: filteredItems,
        isSearching: false,
        searchQuery: '',
      ));
    }
  }

  Future<void> _onSearchMenuItems(
    SearchMenuItems event,
    Emitter<MenuState> emit,
  ) async {
    final currentState = state;
    if (currentState is MenuLoaded) {
      if (event.query.isEmpty) {
        emit(currentState.copyWith(
          filteredItems: currentState.menuItems,
          searchQuery: '',
          isSearching: false,
          selectedCategoryId: null,
        ));
      } else {
        final filteredItems = currentState.menuItems
            .where((item) =>
                item.name.toLowerCase().contains(event.query.toLowerCase()) ||
                item.description.toLowerCase().contains(event.query.toLowerCase()))
            .toList();

        emit(currentState.copyWith(
          filteredItems: filteredItems,
          searchQuery: event.query,
          isSearching: true,
          selectedCategoryId: null,
        ));
      }
    }
  }
}
