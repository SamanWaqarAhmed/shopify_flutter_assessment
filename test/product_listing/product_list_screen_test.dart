import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' show Get;
import 'package:shopify/core/network/api_exception.dart';
import 'package:shopify/features/favorites/controller/favorites_controller.dart';
import 'package:shopify/features/product_listing/controller/providers.dart';
import 'package:shopify/features/product_listing/view/product_list_screen.dart';

import '../helpers/fake_product_repository.dart';

/// Widget tests for the product list screen: loading, data, error + retry, empty.
void main() {
  // The list screen reads favorites from the GetX controller (via the bridge).
  setUp(() => Get.put(FavoritesController()));
  tearDown(() => Get.reset());

  Widget buildScreen(FakeProductRepository repository) {
    return ProviderScope(
      retry: (retryCount, error) => null,
      overrides: [productRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: ProductListScreen()),
    );
  }

  /// Lets the fake futures finish and the widgets rebuild.
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows a loading indicator while products load', (tester) async {
    final repository = FakeProductRepository(delay: const Duration(seconds: 1));

    await tester.pumpWidget(buildScreen(repository));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Let the fake network delay finish so no timer is left pending.
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
  });

  testWidgets('renders products with title and price', (tester) async {
    await tester.pumpWidget(buildScreen(FakeProductRepository()));
    await settle(tester);

    expect(find.text('Product 1'), findsOneWidget);
    expect(find.text('Product 2'), findsOneWidget);
    expect(find.text('\$11.00'), findsOneWidget); // 10.0 + 1
    expect(find.text('All'), findsOneWidget); // category chip
  });

  testWidgets('shows an error with Retry, and recovers after Retry', (tester) async {
    final repository = FakeProductRepository(
      failure: const ApiException(
        type: ApiErrorType.server,
        message: 'Server error (500). Please try again later.',
        statusCode: 500,
      ),
    );

    await tester.pumpWidget(buildScreen(repository));
    await settle(tester);

    expect(
      find.text('Server error (500). Please try again later.'),
      findsOneWidget,
    );
    expect(find.text('Retry'), findsOneWidget);

    repository.failure = null; // the API "comes back"
    await tester.tap(find.text('Retry'));
    await settle(tester);

    expect(find.text('Product 1'), findsOneWidget);
  });

  testWidgets('shows the empty state when there are no products', (tester) async {
    await tester.pumpWidget(buildScreen(FakeProductRepository(total: 0)));
    await settle(tester);

    expect(find.textContaining('No products found'), findsOneWidget);
  });
}
