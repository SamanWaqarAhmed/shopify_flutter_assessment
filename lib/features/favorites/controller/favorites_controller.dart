import 'package:get/get.dart';
import '../../../core/model/product_model.dart';

class FavoritesController extends GetxController {
  final favorites = <Product>[].obs;

  bool isFavorite(int productId) {
    return favorites.any((product) => product.id == productId);
  }

  void toggle(Product product) {
    if (isFavorite(product.id)) {
      favorites.removeWhere((item) => item.id == product.id);
    } else {
      favorites.add(product);
    }
  }
}
