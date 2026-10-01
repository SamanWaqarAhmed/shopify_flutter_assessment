import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' show Get, GetNavigation;
import '../../../../core/model/product_model.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/favorite_button.dart';
import '../../../../core/widgets/product_image.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../../../../routes/app_routes.dart';
import '../../../favorites/controller/favorite_ids_provider.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.productDetailsOf(product.id)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ProductImage(
                  url: product.thumbnail,
                  width: 96,
                  height: 96,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(product.category, style: textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          formatPrice(product.price),
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        RatingBadge(rating: product.rating),
                      ],
                    ),
                  ],
                ),
              ),
              _CardFavoriteButton(product: product),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardFavoriteButton extends ConsumerWidget {
  const _CardFavoriteButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(product.id));

    return FavoriteButton(
      isFavorite: isFavorite,
      onPressed: () => ref.read(favoritesControllerProvider).toggle(product),
    );
  }
}
