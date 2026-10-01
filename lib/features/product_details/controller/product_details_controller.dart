import 'package:get/get.dart';

import '../../../core/model/product_model.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/repositories/product_repository.dart';
import '../../favorites/controller/favorites_controller.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController({
    required ProductRepository repository,
    required FavoritesController favorites,
    required this.productId,
  })  : _repository = repository,
        _favorites = favorites;

  final ProductRepository _repository;
  final FavoritesController _favorites;
  final int productId;

  final product = Rxn<Product>();
  final isLoading = true.obs;
  final errorMessage = RxnString();
  final imageIndex = 0.obs;

  bool get isFavorite => _favorites.isFavorite(productId);

  @override
  void onInit() {
    super.onInit();
    loadProduct();
  }

  Future<void> loadProduct() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      product.value = await _repository.getProduct(productId);
    } on ApiException catch (error) {
      errorMessage.value = error.message;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleFavorite() {
    final current = product.value;
    if (current != null) _favorites.toggle(current);
  }

  void onImageChanged(int index) => imageIndex.value = index;
}
