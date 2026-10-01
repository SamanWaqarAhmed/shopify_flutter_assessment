import 'package:get/get.dart';
import 'package:shopify/features/product_details/controller/product_details_controller.dart';

import '../../../core/repositories/product_repository.dart';
import '../../favorites/controller/favorites_controller.dart';

class ProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final productId = int.parse(Get.parameters['id']!);

    Get.lazyPut<ProductDetailsController>(
      () => ProductDetailsController(
        repository: Get.find<ProductRepository>(),
        favorites: Get.find<FavoritesController>(),
        productId: productId,
      ),
    );
  }
}
