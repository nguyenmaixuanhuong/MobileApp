import 'package:flutter/material.dart';
import 'package:ct484_project/ui/cart/cart_screen.dart';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:provider/provider.dart';

class ShoppingCartButton extends StatelessWidget {
  const ShoppingCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartManager>(builder: (ctx, cartManager, child) {
      return TopRightBadge(
        data: cartManager.productCount,
        child: IconButton(
          icon: const Icon(
            Icons.shopping_basket,
          ),
          onPressed: () {
            Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnmiton) {
                return const CartScreen();
              },
            ));
          },
        ),
      );
    });
  }
}

class TopRightBadge extends StatelessWidget {
  const TopRightBadge({
    required this.child,
    required this.data,
    super.key,
  });
  final Widget child;
  final Object data;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color.fromARGB(255, 0, 176, 192),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              data.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
