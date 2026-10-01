import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart' show Get, Inst, GetResetExt;
import 'package:shopify/app.dart';
import 'package:shopify/features/favorites/controller/favorites_controller.dart';
import 'package:shopify/features/product_listing/controller/providers.dart';

import 'helpers/fake_product_repository.dart';

void main() {
  // main.dart normally registers this. In a test we must do it ourselves.
  setUp(() => Get.put(FavoritesController()));
  tearDown(() => Get.reset());

  testWidgets('Splash shows Shopify branding, then opens the product list', (
    WidgetTester tester,
  ) async {
    // main.dart normally creates the ProviderScope and the real repository.
    // In a test we provide our own, with a fake repository (no network).
    await tester.pumpWidget(
      ProviderScope(
        retry: (retryCount, error) => null,
        overrides: [
          productRepositoryProvider.overrideWithValue(FakeProductRepository()),
        ],
        child: const ShopifyApp(),
      ),
    );

    expect(find.text('Shopify'), findsOneWidget);
    expect(find.text('Your shopping companion'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

    // Advance the fake clock so the splash timer completes and navigates.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500)); // route transition
    await tester.pump(); // products loaded

    expect(find.text('Product 1'), findsOneWidget);
  });
}
