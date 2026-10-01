import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/core/network/api_exception.dart';
import 'package:shopify/features/product_listing/controller/product_filters.dart';
import 'package:shopify/features/product_listing/controller/product_list_notifier.dart';
import 'package:shopify/features/product_listing/controller/providers.dart';

import '../helpers/fake_product_repository.dart';

/// Unit tests for the Riverpod ProductListNotifier (no widgets involved).
void main() {
  /// Creates an isolated Riverpod container that uses the fake repository.
  ProviderContainer makeContainer(FakeProductRepository repository) {
    final container = ProviderContainer(
      retry: (retryCount, error) => null, // show errors immediately
      overrides: [productRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('loads the first page of products', () async {
    final repository = FakeProductRepository();
    final container = makeContainer(repository);

    final state = await container.read(productListProvider.future);

    expect(state.products, hasLength(10));
    expect(state.hasMore, isTrue);
    expect(repository.getProductsCalls, 1);
  });

  test('exposes an error when the API fails', () async {
    final repository = FakeProductRepository(
      failure: const ApiException(
        type: ApiErrorType.server,
        message: 'Server error (500). Please try again later.',
        statusCode: 500,
      ),
    );
    final container = makeContainer(repository);

    await expectLater(
      container.read(productListProvider.future),
      throwsA(isA<ApiException>()),
    );
    expect(container.read(productListProvider).hasError, isTrue);
  });

  test('loadMore appends the next page and stops when there is no more', () async {
    final repository = FakeProductRepository(); // 15 products = 10 + 5
    final container = makeContainer(repository);
    await container.read(productListProvider.future);

    await container.read(productListProvider.notifier).loadMore();

    final state = container.read(productListProvider).value!;
    expect(state.products, hasLength(15));
    expect(state.hasMore, isFalse);
    expect(state.isLoadingMore, isFalse);

    // Nothing left: another call must NOT hit the API again.
    await container.read(productListProvider.notifier).loadMore();
    expect(repository.getProductsCalls, 2); // first page + one load-more
  });

  test('selecting a category reloads the list from the category endpoint', () async {
    final repository = FakeProductRepository();
    final container = makeContainer(repository);
    await container.read(productListProvider.future);

    container.read(selectedCategoryProvider.notifier).select('beauty');
    final state = await container.read(productListProvider.future);

    expect(repository.lastCategory, 'beauty');
    expect(repository.categoryCalls, 1);
    expect(state.products, hasLength(3));
  });

  test('searching (debounced) calls the search endpoint and resets the category', () async {
    final repository = FakeProductRepository();
    final container = makeContainer(repository);
    await container.read(productListProvider.future);
    container.read(selectedCategoryProvider.notifier).select('beauty');

    container.read(searchQueryProvider.notifier).onTextChanged('phone');
    // Wait longer than the 400 ms debounce.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final state = await container.read(productListProvider.future);

    expect(container.read(selectedCategoryProvider), isNull);
    expect(repository.lastQuery, 'phone');
    expect(state.products, hasLength(2));
  });
}
