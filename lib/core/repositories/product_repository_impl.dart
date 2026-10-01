import '../constants/api_constants.dart';
import '../model/product_category.dart';
import '../model/product_model.dart';
import '../model/product_page.dart';
import '../network/api_client.dart';
import '../network/api_exception.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<ProductsPage> getProducts({
    required int skip,
  }) {
    return _fetchPage(
      ApiConstants.productsPath,
      {'skip': skip},
    );
  }

  @override
  Future<ProductsPage> searchProducts({
    required String query,
    required int skip,
  }) {
    return _fetchPage(
      ApiConstants.searchPath,
      {'q': query, 'skip': skip},
    );
  }

  @override
  Future<ProductsPage> getProductsByCategory({
    required String category,
    required int skip,
  }) {
    return _fetchPage(
      ApiConstants.categoryPath(category),
      { 'skip': skip},
    );
  }

  @override
  Future<Product> getProduct(int id) async {
    final json = await _client.get<Map<String, dynamic>>(
      ApiConstants.productPath(id),
    );
    return _parse(() => Product.fromJson(json));
  }

  @override
  Future<List<ProductCategory>> getCategories() async {
    final json = await _client.get<List<dynamic>>(ApiConstants.categoriesPath);
    return _parse(
          () => json.map((item) => ProductCategory.fromJson(item as Object)).toList(),
    );
  }

  Future<ProductsPage> _fetchPage(
      String path,
      Map<String, dynamic> queryParameters,
      ) async {
    final json = await _client.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
    );
    return _parse(() => ProductsPage.fromJson(json));
  }

  T _parse<T>(T Function() parser) {
    try {
      return parser();
    } on TypeError catch (_, stackTrace) {
      Error.throwWithStackTrace(const ApiException.parsing(), stackTrace);
    } on FormatException catch (_, stackTrace) {
      Error.throwWithStackTrace(const ApiException.parsing(), stackTrace);
    }
  }
}