class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String productsPath = '/products';
  static const String searchPath = '/products/search';
  static const String categoriesPath = '/products/categories';

  static String productPath(int id) => '/products/$id';
  static String categoryPath(String slug) => '/products/category/$slug';
  static const int pageSize = 10;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}