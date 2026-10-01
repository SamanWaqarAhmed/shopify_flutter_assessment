import 'package:flutter/material.dart';
import 'package:shopify/features/product_listing/view/widgets/category_chips.dart';
import 'package:shopify/features/product_listing/view/widgets/favorites_action.dart';
import 'package:shopify/features/product_listing/view/widgets/product_list_body.dart';
import 'package:shopify/features/product_listing/view/widgets/product_search_field.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopify'),
        actions: const [FavoritesAction()],
      ),
      body: const Column(
        children: [
          ProductSearchField(),
          CategoryChips(),
          Expanded(child: ProductListBody()),
        ],
      ),
    );
  }
}
