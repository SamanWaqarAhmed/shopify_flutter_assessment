import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' show Get, Inst;

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/repositories/product_repository.dart';
import 'core/repositories/product_repository_impl.dart';
import 'features/favorites/controller/favorites_controller.dart';
import 'features/product_listing/controller/providers.dart';


void main() {
  final ProductRepository repository = ProductRepositoryImpl(ApiClient());

  Get.put<ProductRepository>(repository, permanent: true);
  Get.put(FavoritesController(), permanent: true);

  runApp(
    ProviderScope(
      retry: (retryCount, error) => null,
      overrides: [
        productRepositoryProvider.overrideWithValue(repository),
      ],
      child: const ShopifyApp(),
    ),
  );
}

