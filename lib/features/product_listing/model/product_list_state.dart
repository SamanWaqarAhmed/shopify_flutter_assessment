
import '../../../core/model/product_model.dart';

class ProductListState {
  const ProductListState({
    required this.products,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
  });

  final List<Product> products;
  final bool hasMore;
  final bool isLoadingMore;
  final bool loadMoreFailed;

  ProductListState copyWith({bool? isLoadingMore, bool? loadMoreFailed}) {
    return ProductListState(
      products: products,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
    );
  }
}
