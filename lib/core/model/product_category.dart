class ProductCategory {
  const ProductCategory({required this.slug, required this.name});

  factory ProductCategory.fromJson(Object json) {
    if (json is String) {
      return ProductCategory(slug: json, name: _titleCase(json));
    }
    final map = json as Map<String, dynamic>;
    final slug = map['slug'] as String;
    return ProductCategory(
      slug: slug,
      name: map['name'] as String? ?? _titleCase(slug),
    );
  }

  final String slug;
  final String name;

  static String _titleCase(String slug) {
    return slug
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}