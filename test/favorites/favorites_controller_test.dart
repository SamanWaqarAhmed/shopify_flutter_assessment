import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/features/favorites/controller/favorites_controller.dart';

import '../helpers/fake_product_repository.dart';

/// Unit tests for the GetX FavoritesController.
void main() {
  test('toggle adds a product, toggling again removes it', () {
    final controller = FavoritesController();
    final product = FakeProductRepository.makeProduct(1);

    expect(controller.isFavorite(1), isFalse);

    controller.toggle(product);
    expect(controller.isFavorite(1), isTrue);
    expect(controller.favorites, hasLength(1));

    controller.toggle(product);
    expect(controller.isFavorite(1), isFalse);
    expect(controller.favorites, isEmpty);
  });

  test('keeps different products independent', () {
    final controller = FavoritesController();

    controller.toggle(FakeProductRepository.makeProduct(1));
    controller.toggle(FakeProductRepository.makeProduct(2));
    controller.toggle(FakeProductRepository.makeProduct(1)); // remove only #1

    expect(controller.isFavorite(1), isFalse);
    expect(controller.isFavorite(2), isTrue);
    expect(controller.favorites, hasLength(1));
  });
}
