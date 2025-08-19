import 'package:flutter/material.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSearchTap;
  final ValueChanged<String> onRemoveSearch;

  const RecentSearchesWidget({
    Key? key,
    required this.recentSearches,
    required this.onSearchTap,
    required this.onRemoveSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            const Icon(Icons.history, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 16),
        ...recentSearches.map((query) => Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(Icons.search, color: Colors.grey),
            title: Text(query, style: const TextStyle(fontSize: 16)),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              onPressed: () => onRemoveSearch(query),
            ),
            onTap: () => onSearchTap(query),
          ),
        )),
      ],
    );
  }
}
