import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' show Get, GetNavigation;

import '../../../../routes/app_routes.dart';
import '../../../favorites/controller/favorite_ids_provider.dart';


class FavoritesAction extends ConsumerWidget {
  const FavoritesAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(favoriteIdsProvider.select((ids) => ids.length));

    return IconButton(
      tooltip: 'Favorites',
      onPressed: () => Get.toNamed(AppRoutes.favorites),
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        child: const Icon(Icons.favorite_border),
      ),
    );
  }
}
