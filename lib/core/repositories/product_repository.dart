import '../model/product_category.dart';
import '../model/product_model.dart';
import '../model/product_page.dart';

abstract class ProductRepository {
  Future<ProductsPage> getProducts({
    required int skip,
  });

  Future<ProductsPage> searchProducts({
    required String query,
    required int skip,
  });

  Future<ProductsPage> getProductsByCategory({
    required String category,
    required int skip,
  });

  Future<Product> getProduct(int id);

  Future<List<ProductCategory>> getCategories();
}