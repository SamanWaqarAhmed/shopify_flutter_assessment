import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart' show Get, ever, Inst;

import '../../../core/model/product_model.dart';
import 'favorites_controller.dart';

final favoritesControllerProvider = Provider<FavoritesController>(
  (ref) => Get.find<FavoritesController>(),
);

final favoriteIdsProvider = NotifierProvider<FavoriteIdsNotifier, Set<int>>(FavoriteIdsNotifier.new);

class FavoriteIdsNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    final controller = ref.watch(favoritesControllerProvider);
    final worker = ever<List<Product>>(controller.favorites, (items) {
      state = _idsOf(items);
    });
    ref.onDispose(worker.dispose);

    return _idsOf(controller.favorites);
  }

  Set<int> _idsOf(List<Product> items) => items.map((p) => p.id).toSet();
}

final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  return ref.watch(
    favoriteIdsProvider.select((ids) => ids.contains(productId)),
  );
});
