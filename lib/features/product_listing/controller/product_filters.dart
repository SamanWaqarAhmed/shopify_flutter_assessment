import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Current search text (debounced).
final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

/// Currently selected category slug (null = "All").
final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(
  SelectedCategoryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String> {
  Timer? _debounce;

  @override
  String build() {
    ref.onDispose(() => _debounce?.cancel());
    return '';
  }

  /// Waits until the user stops typing, so we don't call the API on every key.
  void onTextChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _apply(text.trim());
    });
  }

  void clear() {
    _debounce?.cancel();
    state = '';
  }

  void _apply(String query) {
    if (query == state) return;
    // DummyJSON cannot combine search + category, so searching resets category.
    if (query.isNotEmpty) {
      ref.read(selectedCategoryProvider.notifier).select(null);
    }
    state = query;
  }
}

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? slug) {
    // Picking a category resets the search text.
    if (slug != null) {
      ref.read(searchQueryProvider.notifier).clear();
    }
    state = slug;
  }
}
