import 'package:flutter_test/flutter_test.dart';
import 'package:shopify/core/network/api_exception.dart';
import 'package:shopify/features/favorites/controller/favorites_controller.dart';
import 'package:shopify/features/product_details/controller/product_details_controller.dart';

import '../helpers/fake_product_repository.dart';

/// Unit tests for the GetX ProductDetailsController.
void main() {
  ProductDetailsController makeController(
    FakeProductRepository repository,
    FavoritesController favorites,
  ) {
    return ProductDetailsController(
      repository: repository,
      favorites: favorites,
      productId: 7,
    );
  }

  test('loadProduct stores the product and stops loading', () async {
    final controller = makeController(
      FakeProductRepository(),
      FavoritesController(),
    );

    await controller.loadProduct();

    expect(controller.product.value?.id, 7);
    expect(controller.isLoading.value, isFalse);
    expect(controller.errorMessage.value, isNull);
  });

  test('loadProduct exposes the error message when the API fails', () async {
    final controller = makeController(
      FakeProductRepository(
        failure: const ApiException(
          type: ApiErrorType.noConnection,
          message: 'No internet connection.',
        ),
      ),
      FavoritesController(),
    );

    await controller.loadProduct();

    expect(controller.product.value, isNull);
    expect(controller.errorMessage.value, 'No internet connection.');
    expect(controller.isLoading.value, isFalse);
  });

  test('toggleFavorite updates the shared favorites controller', () async {
    final favorites = FavoritesController();
    final controller = makeController(FakeProductRepository(), favorites);
    await controller.loadProduct();

    controller.toggleFavorite();
    expect(controller.isFavorite, isTrue);
    expect(favorites.isFavorite(7), isTrue);

    controller.toggleFavorite();
    expect(controller.isFavorite, isFalse);
  });
}
