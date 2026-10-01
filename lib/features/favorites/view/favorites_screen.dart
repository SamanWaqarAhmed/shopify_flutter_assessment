import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/product_image.dart';
import '../../../routes/app_routes.dart';
import '../controller/favorites_controller.dart';

class FavoritesScreen extends GetView<FavoritesController> {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        final items = controller.favorites;
        if (items.isEmpty) {
          return const EmptyView(
            message: 'No favorites yet.\nTap the heart on a product to save it.',
            icon: Icons.favorite_border,
          );
        }
        return ListView.separated(
          itemCount: items.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final product = items[index];
            return ListTile(
              onTap: () => Get.toNamed(AppRoutes.productDetailsOf(product.id)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ProductImage(
                  url: product.thumbnail,
                  width: 56,
                  height: 56,
                ),
              ),
              title: Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${product.category} • ${formatPrice(product.price)}',
              ),
              trailing: FavoriteButton(
                isFavorite: true,
                onPressed: () => controller.toggle(product),
              ),
            );
          },
        );
      }),
    );
  }
}