part of search_bloc;

abstract class SearchState extends Equatable {
  final List<String> recentSearches;
  const SearchState({this.recentSearches = const []});
  @override List<Object> get props => [recentSearches];
}

class SearchInitial extends SearchState {
  const SearchInitial({List<String> recentSearches = const []}) : super(recentSearches: recentSearches);
}

class SearchLoading extends SearchState {
  final String query;
  const SearchLoading({required this.query, List<String> recentSearches = const []}) : super(recentSearches: recentSearches);
  @override List<Object> get props => [query, recentSearches];
}

class SearchLoaded extends SearchState {
  final String query;
  final List<Restaurant> restaurants;
  final List<MenuItem> menuItems;
  final List<String> suggestions;
  final bool hasResults;
  const SearchLoaded({
    required this.query,
    required this.restaurants,
    required this.menuItems,
    required this.suggestions,
    required this.hasResults,
    List<String> recentSearches = const [],
  }) : super(recentSearches: recentSearches);
  @override List<Object> get props => [query, restaurants, menuItems, suggestions, hasResults, recentSearches];
}

class SearchError extends SearchState {  // FIXED: Added missing SearchError state
  final String message;
  final String query;
  const SearchError({
    required this.message,
    required this.query,
    List<String> recentSearches = const [],
  }) : super(recentSearches: recentSearches);
  @override List<Object> get props => [message, query, recentSearches];
}
