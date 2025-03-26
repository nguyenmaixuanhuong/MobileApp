import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:ct484_project/ui/listscreen.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(this.product, {super.key});
  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(255, 238, 238, 238), // Màu sắc của đổ bóng
            blurRadius: 5.0, // Bán kính của đổ bóng (độ mờ)
            spreadRadius: 2.0, // Bán kính mở rộng của đổ bóng
            offset: Offset(0, 2), // Vị trí của đổ bóng (theo trục x, y)
          ),
        ],
      ),
      child: GridTile(
        header: GridTileBar(
            leading: ValueListenableBuilder<bool>(
          valueListenable: product.isFavoriteListenable,
          builder: (ctx, isFavorite, child) {
            return IconButton(
              icon: Icon(
                size: 18,
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: const Color.fromARGB(255, 255, 115, 105),
              onPressed: () {
                context.read<ProductsManager>().toggleFavoriteStatus(product);
              },
            );
          },
        )),
        footer: ProductGridFooter(
          product: product,
          onAddToCartPressed: () {
           context.read<CartManager>().addItem(product, 1);
           ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar( 
                  SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.all(0),
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromARGB(255, 0, 185, 6),
                      ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Thêm vào giỏ hàng thành công',style: TextStyle(color: Colors.white),)
                      ],
                    )
                  ),
                  duration: const Duration(seconds: 1),
                ));
          },
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class ProductGridFooter extends StatelessWidget {
  const ProductGridFooter({
    super.key,
    required this.product,
    this.onAddToCartPressed,
  });
  final Product product;
  final void Function()? onAddToCartPressed;

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      // backgroundColor: Color.fromARGB(9, 216, 216, 216),
      title: Text(
        product.nameProduct,
        textAlign: TextAlign.start,
        style: const TextStyle(
            fontSize: 10, height: 3, color: Color.fromARGB(255, 74, 74, 74)),
      ),
      trailing: IconButton(
        icon: const Icon(
          size: 18,
          Icons.shopping_cart,
        ),
        onPressed: onAddToCartPressed,
        color: Theme.of(context).colorScheme.surfaceTint,
      ),
    );
  }
}
