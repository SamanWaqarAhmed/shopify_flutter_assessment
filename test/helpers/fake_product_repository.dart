import 'dart:math';

import 'package:shopify/core/constants/api_constants.dart';
import 'package:shopify/core/model/product_category.dart';
import 'package:shopify/core/model/product_model.dart';
import 'package:shopify/core/model/product_page.dart';
import 'package:shopify/core/network/api_exception.dart';
import 'package:shopify/core/repositories/product_repository.dart';

/// A fake repository for tests. No network, fully predictable data.
///
/// - [total]   : how many products "exist" (default 15 = two pages of 10)
/// - [delay]   : optional fake network delay
/// - [failure] : when not null, EVERY call throws it (set it to null later to
///               simulate "the API recovered")
class FakeProductRepository implements ProductRepository {
  FakeProductRepository({this.total = 15, this.delay, this.failure});

  final int total;
  final Duration? delay;
  ApiException? failure;

  // Call counters so tests can check which endpoint was used.
  int getProductsCalls = 0;
  int searchCalls = 0;
  int categoryCalls = 0;
  String? lastQuery;
  String? lastCategory;

  /// Builds a product with predictable values: "Product 1", price 11.00, ...
  static Product makeProduct(int id) {
    return Product(
      id: id,
      title: 'Product $id',
      description: 'Description $id',
      category: 'beauty',
      price: 10.0 + id,
      discountPercentage: 5,
      rating: 4.5,
      stock: 20,
      brand: 'Brand',
      thumbnail: 'https://example.com/$id.png',
      images: ['https://example.com/$id.png'],
    );
  }

  Future<void> _simulateNetwork() async {
    final wait = delay;
    if (wait != null) await Future<void>.delayed(wait);
    final error = failure;
    if (error != null) throw error;
  }

  ProductsPage _page({
    required int skip,
    required int limit,
    required int count,
  }) {
    final end = min(skip + limit, count);
    return ProductsPage(
      products: [for (var id = skip + 1; id <= end; id++) makeProduct(id)],
      total: count,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<ProductsPage> getProducts({
    required int skip,
    int limit = ApiConstants.pageSize,
  }) async {
    getProductsCalls++;
    await _simulateNetwork();
    return _page(skip: skip, limit: limit, count: total);
  }

  @override
  Future<ProductsPage> searchProducts({
    required String query,
    required int skip,
    int limit = ApiConstants.pageSize,
  }) async {
    searchCalls++;
    lastQuery = query;
    await _simulateNetwork();
    return _page(skip: skip, limit: limit, count: 2); // search finds 2 items
  }

  @override
  Future<ProductsPage> getProductsByCategory({
    required String category,
    required int skip,
    int limit = ApiConstants.pageSize,
  }) async {
    categoryCalls++;
    lastCategory = category;
    await _simulateNetwork();
    return _page(skip: skip, limit: limit, count: 3); // category has 3 items
  }

  @override
  Future<Product> getProduct(int id) async {
    await _simulateNetwork();
    return makeProduct(id);
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    await _simulateNetwork();
    return const [
      ProductCategory(slug: 'beauty', name: 'Beauty'),
      ProductCategory(slug: 'laptops', name: 'Laptops'),
    ];
  }
}
