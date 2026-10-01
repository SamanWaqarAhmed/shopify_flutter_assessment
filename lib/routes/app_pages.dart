import 'package:get/get.dart';
import '../features/favorites/view/favorites_screen.dart';
import '../features/product_details/controller/product_details_binding.dart';
import '../features/product_details/view/product_details_screen.dart';
import '../features/product_listing/view/product_list_screen.dart';
import '../features/splash_screen/splash_screen.dart';
import 'app_routes.dart';

abstract final class AppPages {
  static final List<GetPage<dynamic>> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.home,
      page: () => const ProductListScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.favorites,
      page: () => const FavoritesScreen(),
    ),
    GetPage<dynamic>(
      name: AppRoutes.productDetails,
      page: () => const ProductDetailsScreen(),
      binding: ProductDetailsBinding(),
    ),
  ];
}
