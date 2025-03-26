import 'package:ct484_project/ui/listscreen.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:ct484_project/ui/products/product_grid.dart';
import 'package:provider/provider.dart';

class ProductsFavoriteScreen extends StatefulWidget {
  const ProductsFavoriteScreen({super.key});
  static const routeName = '/favorite';

  @override
  State<ProductsFavoriteScreen> createState() => _ProductsFavoriteScreenState();
}

class _ProductsFavoriteScreenState extends State<ProductsFavoriteScreen> {
   late Future<void> _fetchProducts;  
    @override
    void initState() {
      super.initState();
      _fetchProducts = context.read<ProductsManager>().fetchProducts();
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sản phẩm yêu thích',
          style: TextStyle(fontSize: 15),
        ),
        actions: const <Widget>[
          ShoppingCartButton(),
        ],
      ),
      body: FutureBuilder(
              future: _fetchProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const ProductGrid('', true);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
    );
  }
}
