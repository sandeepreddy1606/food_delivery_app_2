library search_bloc;

import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // ADDED: For debugPrint
import '../../../domain/entities/restaurant.dart';
import '../../../domain/entities/menu_item.dart';
import '../../../domain/repositories/restaurant_repository.dart';
import '../../../domain/repositories/menu_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RestaurantRepository restaurantRepository;
  final MenuRepository menuRepository;
  final SharedPreferences prefs; // ADDED
  Timer? _debounceTimer;
  static const _historyKey = 'recent_searches'; // ADDED

  SearchBloc({
    required this.restaurantRepository,
    required this.menuRepository,
    required this.prefs, // ADDED
  }) : super(const SearchInitial()) {
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<AddToRecentSearches>(_onAddToRecentSearches);
    on<ClearSearch>(_onClearSearch);
    on<SearchCategorySelected>(_onSearchCategorySelected);
    on<RemoveRecentSearch>(_onRemoveRecentSearch);
  }

  Future<void> _onLoadRecentSearches(LoadRecentSearches _, Emitter<SearchState> emit) async {
    try {
      if (kDebugMode) {
        print('📚 Loading recent searches...'); // Debug print
      }
      final list = prefs.getStringList(_historyKey) ?? [];
      if (kDebugMode) {
        print('📚 Loaded ${list.length} recent searches: $list'); // Debug print
      }
      emit(SearchInitial(recentSearches: list));
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error loading recent searches: $e'); // Debug print
      }
      emit(const SearchInitial(recentSearches: []));
    }
  }

  Future<void> _onAddToRecentSearches(AddToRecentSearches e, Emitter<SearchState> emit) async {
    try {
      if (kDebugMode) {
        print('➕ Adding to recent searches: "${e.query}"'); // Debug print
      }
      final list = prefs.getStringList(_historyKey) ?? [];
      list.remove(e.query);
      list.insert(0, e.query);
      if (list.length > 5) list.removeLast(); // limit to 5
      await prefs.setStringList(_historyKey, list);
      if (kDebugMode) {
        print('✅ Recent searches updated: $list'); // Debug print
      }
      emit(SearchInitial(recentSearches: list));
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error adding to recent searches: $e'); // Debug print
      }
    }
  }

  Future<void> _onRemoveRecentSearch(RemoveRecentSearch e, Emitter<SearchState> emit) async {
    try {
      if (kDebugMode) {
        print('🗑️ Removing from recent searches: "${e.query}"'); // Debug print
      }
      final list = prefs.getStringList(_historyKey) ?? [];
      list.remove(e.query);
      await prefs.setStringList(_historyKey, list);
      if (kDebugMode) {
        print('✅ Recent searches after removal: $list'); // Debug print
      }
      emit(SearchInitial(recentSearches: list));
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error removing recent search: $e'); // Debug print
      }
    }
  }

  Future<void> _onClearSearch(ClearSearch _, Emitter<SearchState> emit) async {
    try {
      if (kDebugMode) {
        print('🧹 Clearing search and returning to initial state'); // Debug print
      }
      final list = prefs.getStringList(_historyKey) ?? [];
      emit(SearchInitial(recentSearches: list));
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing search: $e'); // Debug print
      }
      emit(const SearchInitial(recentSearches: []));
    }
  }

  // CRITICAL FIX: This method was causing the emit() after event handler completion error
  Future<void> _onSearchQueryChanged(SearchQueryChanged e, Emitter<SearchState> emit) async {
    // Cancel any existing timer
    _debounceTimer?.cancel();
    
    final q = e.query.trim();
    if (kDebugMode) {
      print('🔍 Search query changed: "$q"'); // Debug print
    }
    
    if (q.isEmpty) {
      final hist = prefs.getStringList(_historyKey) ?? [];
      if (kDebugMode) {
        print('🔍 Empty query, returning to initial state'); // Debug print
      }
      return emit(SearchInitial(recentSearches: hist));
    }

    // Show loading state immediately
    emit(SearchLoading(query: q, recentSearches: prefs.getStringList(_historyKey) ?? []));
    
    // CRITICAL FIX: Create a Completer to properly handle the async Timer
    final completer = Completer<void>();
    
    // Set up the debounced search
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      try {
        if (kDebugMode) {
          print('🎯 Executing search for: "$q"'); // Debug print
        }

        final rs = await restaurantRepository.searchRestaurants(q);
        final items = await _searchAllMenuItems(q);
        
        if (kDebugMode) {
          print('📊 Search completed: ${rs.length} restaurants, ${items.length} menu items'); // Debug print
        }

        final sugg = _generateSuggestions(q, rs, items);
        final hasResults = rs.isNotEmpty || items.isNotEmpty;
        
        if (kDebugMode) {
          print('💡 Generated ${sugg.length} suggestions'); // Debug print
          print('✅ Has results: $hasResults'); // Debug print
        }

        // CRITICAL FIX: Check if emit is still valid before calling
        if (!emit.isDone) {
          emit(SearchLoaded(
            query: q,
            restaurants: rs,
            menuItems: items,
            suggestions: sugg,
            hasResults: hasResults,
            recentSearches: prefs.getStringList(_historyKey) ?? [],
          ));
        }
        
        completer.complete();
      } catch (error) {
        if (kDebugMode) {
          print('❌ Search error for "$q": $error'); // Debug print
        }
        
        // CRITICAL FIX: Check if emit is still valid before calling
        if (!emit.isDone) {
          emit(SearchError(
            message: 'Search failed: ${error.toString()}',
            query: q,
            recentSearches: prefs.getStringList(_historyKey) ?? [],
          ));
        }
        
        completer.complete();
      }
    });
    
    // CRITICAL FIX: Await the completer to ensure the event handler waits for the Timer
    await completer.future;
  }

  Future<List<MenuItem>> _searchAllMenuItems(String q) async {
    try {
      if (kDebugMode) {
        print('🍽️ Searching menu items for: "$q"'); // Debug print
      }
      
      final all = await restaurantRepository.getRestaurants();
      final items = <MenuItem>[];
      
      for (final r in all) {
        try {
          final menuItems = await menuRepository.getMenuItems(r.id);
          items.addAll(menuItems);
          if (kDebugMode) {
            print('🍽️ Added ${menuItems.length} items from ${r.name}'); // Debug print
          }
        } catch (_) {
          if (kDebugMode) {
            print('⚠️ Failed to load menu for ${r.name}'); // Debug print
          }
          // Ignore individual restaurant menu fetch errors
        }
      }
      
      final matchingItems = items.where((i) =>
          i.name.toLowerCase().contains(q.toLowerCase()) ||
          i.description.toLowerCase().contains(q.toLowerCase())
      ).toList();
      
      if (kDebugMode) {
        print('🍽️ Found ${matchingItems.length} matching menu items'); // Debug print
      }
      
      return matchingItems;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error searching menu items: $e'); // Debug print
      }
      return [];
    }
  }

  List<String> _generateSuggestions(String q, List<Restaurant> rs, List<MenuItem> ms) {
    try {
      if (kDebugMode) {
        print('💡 Generating suggestions for: "$q"'); // Debug print
      }
      
      final s = <String>[];
      for (var r in rs.take(3)) {
        if (!s.contains(r.name)) {
          s.add(r.name);
        }
      }
      for (var m in ms.take(3)) {
        if (!s.contains(m.name)) {
          s.add(m.name);
        }
      }
      
      if (kDebugMode) {
        print('💡 Generated suggestions: $s'); // Debug print
      }
      
      return s;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error generating suggestions: $e'); // Debug print
      }
      return [];
    }
  }

  Future<void> _onSearchCategorySelected(SearchCategorySelected e, Emitter<SearchState> emit) async {
    try {
      if (kDebugMode) {
        print('🏷️ Category selected: "${e.category}"'); // Debug print
      }
      
      final list = prefs.getStringList(_historyKey) ?? [];
      emit(SearchLoading(query: e.category, recentSearches: list));
      
      final rs = await restaurantRepository.getRestaurantsByCategory(e.category);
      
      if (kDebugMode) {
        print('🏷️ Found ${rs.length} restaurants in category "${e.category}"'); // Debug print
      }
      
      emit(SearchLoaded(
        query: e.category,
        restaurants: rs,
        menuItems: const [],
        suggestions: const [],
        hasResults: rs.isNotEmpty,
        recentSearches: list,
      ));
    } catch (error) {
      if (kDebugMode) {
        print('❌ Category search error: $error'); // Debug print
      }
      emit(SearchError(
        message: 'Failed to load ${e.category} restaurants: ${error.toString()}',
        query: e.category,
        recentSearches: prefs.getStringList(_historyKey) ?? [],
      ));
    }
  }

  @override
  Future<void> close() {
    if (kDebugMode) {
      print('🔚 SearchBloc closing, cancelling timer'); // Debug print
    }
    _debounceTimer?.cancel();
    return super.close();
  }
}