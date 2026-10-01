import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopify/features/product_listing/view/widgets/product_card.dart';

import '../../../../core/utils/error_message.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../controller/product_list_notifier.dart';
import 'load_more_footer.dart';

class ProductListBody extends ConsumerWidget {
  const ProductListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(
      productListProvider.select((async) => async.whenData((s) => s.products)),
    );
    final notifier = ref.read(productListProvider.notifier);

    return productsAsync.when(
      loading: () => const LoadingView(),
      error: (error, stackTrace) => ErrorView(
        message: errorMessageOf(error),
        onRetry: notifier.refresh,
      ),
      data: (products) {
        if (products.isEmpty) {
          return const EmptyView(
            message: 'No products found.\nTry another search or category.',
            icon: Icons.search_off,
          );
        }
        return RefreshIndicator(
          onRefresh: notifier.refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter < 300) {
                notifier.loadMore();
              }
              return false;
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length + 1, // +1 for the footer
              itemBuilder: (context, index) {
                if (index == products.length) return const LoadMoreFooter();
                final product = products[index];
                return ProductCard(key: ValueKey(product.id), product: product);
              },
            ),
          ),
        );
      },
    );
  }
}
