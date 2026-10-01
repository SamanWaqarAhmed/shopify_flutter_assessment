abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String favorites = '/favorites';
  static const String productDetails = '/product/:id';

  static String productDetailsOf(int id) => '/product/$id';
}
