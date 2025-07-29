class MenuCategory {
  final String id;
  final String name;
  final String description;
  final String iconUrl;
  final int sortOrder;
  final bool isActive;

  MenuCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.sortOrder,
    required this.isActive,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'MenuCategory(id: $id, name: $name)';
  }
}
