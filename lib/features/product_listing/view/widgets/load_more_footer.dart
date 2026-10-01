import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/product_list_notifier.dart';

class LoadMoreFooter extends ConsumerWidget {
  const LoadMoreFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      productListProvider.select((a) => a.value?.isLoadingMore ?? false),
    );
    final failed = ref.watch(
      productListProvider.select((a) => a.value?.loadMoreFailed ?? false),
    );

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (failed) {
      return Center(
        child: TextButton.icon(
          onPressed: () =>
              ref.read(productListProvider.notifier).loadMore(isRetry: true),
          icon: const Icon(Icons.refresh),
          label: const Text('Could not load more. Tap to retry'),
        ),
      );
    }
    return const SizedBox(height: 16);
  }
}
