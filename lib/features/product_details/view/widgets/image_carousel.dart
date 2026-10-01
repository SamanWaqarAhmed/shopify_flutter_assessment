import 'package:flutter/material.dart';
import 'package:get/get.dart' show Obx, RxInt;

import '../../../../core/widgets/product_image.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({
    super.key,
    required this.images,
    required this.currentIndex,
    required this.onPageChanged,
  });

  final List<String> images;
  final RxInt currentIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) =>
                ProductImage(url: images[index], fit: BoxFit.contain),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => _Dot(isActive: index == currentIndex.value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? color : color.withValues(alpha: 0.25),
      ),
    );
  }
}
