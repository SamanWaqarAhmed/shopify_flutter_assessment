import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shopify/features/product_details/view/widgets/product_details_content.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/loading_view.dart';
import '../controller/product_details_controller.dart';


class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          Obx(() {
            if (controller.product.value == null) {
              return const SizedBox.shrink();
            }
            return FavoriteButton(
              isFavorite: controller.isFavorite,
              onPressed: controller.toggleFavorite,
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const LoadingView();

        final error = controller.errorMessage.value;
        if (error != null) {
          return ErrorView(message: error, onRetry: controller.loadProduct);
        }

        final product = controller.product.value;
        if (product == null) return const SizedBox.shrink();

        return ProductDetailsContent(
          product: product,
          imageIndex: controller.imageIndex,
          onImageChanged: controller.onImageChanged,
        );
      }),
    );
  }
}
