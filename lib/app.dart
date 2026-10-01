import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/routes/app_pages.dart';
import 'package:shopify/routes/app_routes.dart';

class ShopifyApp extends StatelessWidget {
  const ShopifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shopify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}
