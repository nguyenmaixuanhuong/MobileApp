import 'dart:math';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:ct484_project/ui/listscreen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import 'product_card.dart';


class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen(this.product, {super.key});
  final Product product;
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _value = 1;

  void _increment() {
    setState(() {
      _value++;
    });
  }

  void _decrement() {
    setState(() {
      if (_value > 1) {
        _value--;
      } else {
        _value = 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          ShoppingCartButton(),
        ],
      ),
      // drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Stack(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child:
                    Image.network(widget.product.imageUrl, fit: BoxFit.contain),
              ),
              Positioned(
                  top: 16,
                  right: 16,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: widget.product.isFavoriteListenable,
                    builder: (ctx, isFavorite, child) {
                      return IconButton(
                        onPressed: () {
                          context
                              .read<ProductsManager>()
                              .toggleFavoriteStatus(widget.product);
                        },
                        icon: Icon(widget.product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        color: const Color.fromARGB(255, 220, 0, 0),
                        iconSize: 30,
                      );
                    },
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.product.nameProduct.toUpperCase(),
            style: const TextStyle(
                color: Color.fromARGB(255, 175, 0, 0),
                fontWeight: FontWeight.bold),
          ),
          const Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 80,
            endIndent: 80,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Center(
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: _decrement,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 249, 238),
                              padding: const EdgeInsets.all(10),
                              minimumSize: const Size(10, 10)),
                          child: const Icon(
                            Icons.remove,
                            size: 15,
                          )),
                      SizedBox(
                        width: 50.0,
                        height: 40,
                        child: TextFormField(
                          style: const TextStyle(fontSize: 24),
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(text: '$_value'),
                          onChanged: (value) => {
                            setState(() {
                              _value = int.tryParse(value) ?? 0;
                            })
                          },
                        ),
                      ),
                      ElevatedButton(
                          onPressed: _increment,
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 249, 238),
                              padding: const EdgeInsets.all(10),
                              minimumSize: const Size(10, 10)),
                          child: const Icon(
                            Icons.add,
                            size: 15,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              widget.product.description,
              textAlign: TextAlign.center,
              softWrap: true,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ]),
      ),
      bottomNavigationBar: BottomBar(
        number: _value,
        onAddToCartPressed: () {},
        product: widget.product,
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final int number;
  final VoidCallback onAddToCartPressed;
  Product product;
  BottomBar(
      {super.key,
      required this.number,
      required this.onAddToCartPressed,
      required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Giá: ${NumberFormat.decimalPattern().format(product.price * number)}',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          FilledButton(
            onPressed: () {
              context.read<CartManager>().addItem(product, number);
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
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 188, 1, 1)),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_basket,
                  size: 20,
                  color: Color.fromARGB(221, 255, 255, 255),
                ),
                Text(
                  'Thêm vào giỏ hàng',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
