import 'package:flutter/material.dart';
import 'package:get/get.dart' show RxInt;

import '../../../../core/model/product_model.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/rating_badge.dart';
import 'image_carousel.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    super.key,
    required this.product,
    required this.imageIndex,
    required this.onImageChanged,
  });

  final Product product;
  final RxInt imageIndex;
  final ValueChanged<int> onImageChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final images =
        product.images.isEmpty ? [product.thumbnail] : product.images;

    return ListView(
      children: [
        ImageCarousel(
          images: images,
          currentIndex: imageIndex,
          onPageChanged: onImageChanged,
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.title, style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    formatPrice(product.price),
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (product.discountPercentage > 0)
                    Chip(
                      label: Text(
                        '${product.discountPercentage.toStringAsFixed(1)}% off',
                      ),
                    ),
                  const Spacer(),
                  RatingBadge(rating: product.rating),
                ],
              ),
              const Divider(height: 32),
              _InfoRow(label: 'Brand', value: product.brand ?? 'N/A'),
              _InfoRow(label: 'Category', value: product.category),
              _InfoRow(label: 'Stock', value: '${product.stock} available'),
              const SizedBox(height: 16),
              Text('Description', style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(product.description),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
