import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopify/features/product_listing/controller/product_filters.dart';
import 'package:shopify/features/product_listing/controller/providers.dart';

import '../../../core/model/product_page.dart';
import '../../../core/network/api_exception.dart';
import '../model/product_list_state.dart';


final productListProvider =
    AsyncNotifierProvider<ProductListNotifier, ProductListState>(
  ProductListNotifier.new,
);

class ProductListNotifier extends AsyncNotifier<ProductListState> {
  @override
  Future<ProductListState> build() async {
    final query = ref.watch(searchQueryProvider);
    final category = ref.watch(selectedCategoryProvider);

    final page = await _fetchPage(query: query, category: category, skip: 0);
    return ProductListState(products: page.products, hasMore: page.hasMore);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
    }
  }

  Future<void> loadMore({bool isRetry = false}) async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;
    if (current.loadMoreFailed && !isRetry) return;
    final query = ref.read(searchQueryProvider);
    final category = ref.read(selectedCategoryProvider);

    state = AsyncData(
      current.copyWith(isLoadingMore: true, loadMoreFailed: false),
    );

    try {
      final page = await _fetchPage(
        query: query,
        category: category,
        skip: current.products.length,
      );

      final filtersChanged = query != ref.read(searchQueryProvider) ||
          category != ref.read(selectedCategoryProvider);
      if (filtersChanged) return;

      state = AsyncData(
        ProductListState(
          products: [...current.products, ...page.products],
          hasMore: page.hasMore,
        ),
      );
    } on ApiException {
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreFailed: true),
      );
    }
  }

  Future<ProductsPage> _fetchPage({
    required String query,
    required String? category,
    required int skip,
  }) {
    final repository = ref.read(productRepositoryProvider);
    if (query.isNotEmpty) {
      return repository.searchProducts(query: query, skip: skip);
    }
    if (category != null) {
      return repository.getProductsByCategory(category: category, skip: skip);
    }
    return repository.getProducts(skip: skip);
  }
}
