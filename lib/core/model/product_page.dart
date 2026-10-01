import 'package:shopify/core/model/product_model.dart';

class ProductsPage {
  const ProductsPage({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ProductsPage.fromJson(Map<String, dynamic> json) {
    final items = json['products'] as List<dynamic>;
    return ProductsPage(
      products: items
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
    );
  }

  final List<Product> products;
  final int total;
  final int skip;
  final int limit;
  int get nextSkip => skip + products.length;

  bool get hasMore => nextSkip < total;
}