import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/model/product_category.dart';
import '../../../core/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => throw UnimplementedError('Override productRepositoryProvider'),
);

final categoriesProvider = FutureProvider<List<ProductCategory>>((ref) {
  return ref.watch(productRepositoryProvider).getCategories();
});
