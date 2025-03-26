import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_card.dart';
import 'products_manager.dart';

class ProductGrid extends StatelessWidget {
  final String nameCategory;
  final bool showFavorites;
  const ProductGrid(this.nameCategory, this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer <ProductsManager>(builder: (ctx, product, child) {
      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: showFavorites ? product.favoriteItems.length : (nameCategory == '' ? product.itemCount : product.getProductsByCategory(nameCategory).length),
        itemBuilder: (ctx, i) => GridTile(child: ProductCard(showFavorites ? product.favoriteItems[i] : (nameCategory != '' ? product.getProductsByCategory(nameCategory)[i] :product.items[i]))),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
        ),
      );
    });
  }
}
