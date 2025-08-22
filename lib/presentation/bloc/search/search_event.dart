part of search_bloc;

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override List<Object?> get props => [];
}

class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override List<Object?> get props => [query];
}

class SearchCategorySelected extends SearchEvent {
  final String category;
  const SearchCategorySelected(this.category);
  @override List<Object?> get props => [category];
}

class ClearSearch extends SearchEvent {}

class AddToRecentSearches extends SearchEvent {
  final String query;
  const AddToRecentSearches(this.query);
  @override List<Object?> get props => [query];
}

class LoadRecentSearches extends SearchEvent {}

class RemoveRecentSearch extends SearchEvent {
  final String query;
  const RemoveRecentSearch(this.query);
  @override List<Object?> get props => [query];
}
