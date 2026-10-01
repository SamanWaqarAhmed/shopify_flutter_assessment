import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/product_filters.dart';
import '../../controller/providers.dart';

class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);
    final notifier = ref.read(selectedCategoryProvider.notifier);

    return SizedBox(
      height: 56,
      child: categoriesAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (error, stackTrace) => Center(
          child: TextButton.icon(
            onPressed: () => ref.invalidate(categoriesProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Could not load categories. Retry'),
          ),
        ),
        data: (categories) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Center(
                child: ChoiceChip(
                  label: const Text('All'),
                  selected: selected == null,
                  onSelected: (_) => notifier.select(null),
                ),
              );
            }
            final category = categories[index - 1];
            return Center(
              child: ChoiceChip(
                label: Text(category.name),
                selected: selected == category.slug,
                onSelected: (_) => notifier.select(category.slug),
              ),
            );
          },
        ),
      ),
    );
  }
}
