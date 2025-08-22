// lib/presentation/pages/search_page.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/injection_container.dart' as di;
import '../bloc/search/search_bloc.dart';
import '../widgets/recent_searches_widget.dart';
import '../widgets/no_results_widget.dart';
import '../widgets/search_result_widget.dart';

class SearchPage extends StatefulWidget {
  final String? initialQuery;
  const SearchPage({Key? key, this.initialQuery}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController _searchController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    _searchController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the content in BlocProvider so context.read<SearchBloc>() works inside _SearchPageContent
    return BlocProvider(
      create: (_) => di.sl<SearchBloc>()..add(LoadRecentSearches()),
      child: _SearchPageContent(
        searchController: _searchController,
        focusNode: _focusNode,
      ),
    );
  }
}

class _SearchPageContent extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;

  const _SearchPageContent({
    Key? key,
    required this.searchController,
    required this.focusNode,
  }) : super(key: key);

  void _performSearch(BuildContext context) {
    final q = searchController.text.trim();
    if (q.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter something to search')),
      );
      return;
    }
    context.read<SearchBloc>().add(SearchQueryChanged(q));
    context.read<SearchBloc>().add(AddToRecentSearches(q));
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        title: TextField(
          controller: searchController,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: 'Search restaurants, dishes, cuisines…',
            border: InputBorder.none,
          ),
          onChanged: (q) {
            if (kDebugMode) debugPrint('onChanged: $q');
            context.read<SearchBloc>().add(SearchQueryChanged(q));
          },
          onSubmitted: (q) {
            if (q.trim().isNotEmpty) {
              context.read<SearchBloc>().add(AddToRecentSearches(q.trim()));
            }
          },
        ),
        actions: [
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.orange),
              tooltip: 'Search',
              onPressed: () => _performSearch(context),
            ),
          if (searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              tooltip: 'Clear',
              onPressed: () {
                searchController.clear();
                context.read<SearchBloc>().add(ClearSearch());
                focusNode.requestFocus();
              },
            ),
        ],
      ),
      floatingActionButton: searchController.text.isNotEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.search),
              backgroundColor: Colors.orange,
              onPressed: () => _performSearch(context),
            )
          : null,
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            if (state.recentSearches.isEmpty) {
              return const Center(
                child: Text('No recent searches', style: TextStyle(color: Colors.grey)),
              );
            }
            return RecentSearchesWidget(
              recentSearches: state.recentSearches,
              onSearchTap: (q) {
                searchController.text = q;
                context.read<SearchBloc>().add(SearchQueryChanged(q));
              },
              onRemoveSearch: (q) => context.read<SearchBloc>().add(RemoveRecentSearch(q)),
            );
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          }
          if (state is SearchLoaded) {
            if (!state.hasResults) {
              return NoResultsWidget(
                query: state.query,
                onTryAgain: () {
                  searchController.clear();
                  context.read<SearchBloc>().add(ClearSearch());
                  focusNode.requestFocus();
                },
              );
            }
            return SearchResultWidget(
              query: state.query,
              restaurants: state.restaurants,
              menuItems: state.menuItems,
              suggestions: state.suggestions,
              onSuggestionTap: (s) {
                searchController.text = s;
                context.read<SearchBloc>().add(SearchQueryChanged(s));
              },
            );
          }
          if (state is SearchError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
