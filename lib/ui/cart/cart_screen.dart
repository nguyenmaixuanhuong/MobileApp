import 'dart:math';
import 'package:ct484_project/models/order_item.dart';
import 'package:ct484_project/models/product.dart';
import 'package:ct484_project/ui/orders/orders_manager.dart';
import 'package:ct484_project/ui/share/dialog_utils.dart';
import 'package:ct484_project/ui/products/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'cart_manager.dart';
import 'cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<void> _fetchCartItems;
  @override
  void initState() {
    super.initState();
    _fetchCartItems = context.read<CartManager>().fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 137, 0, 0),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Giỏ Hàng '),
            Text(
              '(${cart.productCount})',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        // backgroundColor: Color.fromRGBO(143, 0, 0, 1),
      ),
      body: FutureBuilder(
          future: _fetchCartItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(children: <Widget>[
                Expanded(
                  child: CartItemList(cart),
                ),
                const SizedBox(
                  height: 10,
                ),
              ]);
            }
            return Center(
                child: Lottie.network(
                    'https://lottie.host/664d5ad7-d8ba-48b7-8dca-b4b506cb8926/OrSvcDYftE.json'));
          }),
      bottomNavigationBar: CartSummary(cart: cart),
    );
  }
}

class CartItemList extends StatelessWidget {
  const CartItemList(
    this.cart, {
    super.key,
  });

  final CartManager cart;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: cart.productEntries.map((entry) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: entry.key,
            );
          },
          child: CartItemCard(
            productId: entry.key,
            cartItem: entry.value,
          ),
        );
      }).toList(),
    );
  }
}

class CartSummary extends StatefulWidget {
  const CartSummary({super.key, required this.cart});
  final CartManager cart;

  @override
  State<CartSummary> createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final _editForm = GlobalKey<FormState>();
  late OrderItem _inforOrderItem;
  Future<void> _saveForm() async {
    final isValid = _editForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _editForm.currentState!.save();

    try {
      final ordersManager = context.read<OrdersManager>();
      if (widget.cart.totalAmount > 0) {
        _inforOrderItem =
            _inforOrderItem.copyWith(amount: widget.cart.totalAmount);
        _inforOrderItem =
            _inforOrderItem.copyWith(products: widget.cart.products);
        ordersManager.addOrder(_inforOrderItem);
        widget.cart.clearAllItems();
      } else {
        null;
      }
    } catch (error) {
      if (mounted) {
        await showErrorDialog(context, 'Đã có lỗi xảy ra');
      }
    }
    if (mounted) {
    Navigator.of(context).pop();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Lottie.network(
                      'https://lottie.host/7217fa3f-f679-4251-9eeb-bc62c0a362e6/hHOwdikCjO.json',
                    ),
                  ),
                  const Positioned(
                    bottom: 0,
                    child: Text(
                      'Bạn đã đặt hàng thành công',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          });
    }
    Future.delayed(const Duration(seconds: 10), () {
    Navigator.of(context).pop();
  });
  }

  @override
  void initState() {
    _inforOrderItem = OrderItem(
      id: null,
      amount: 0,
      products: [],
      dateTime: DateTime.now(),
      phoneNumber: '',
      address: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(143, 0, 0, 1),
      child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                // '\$${toStringAsFixed(2)}',
                'Tổng: ${NumberFormat.decimalPattern().format(widget.cart.totalAmount)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                // style: Theme.of(context).primaryTextTheme.titleLarge,
              ),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text(
                                  'Xác nhận đơn hàng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 108, 108, 108),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Form(
                                    key: _editForm,
                                    child: Column(
                                      children: <Widget>[
                                        _buildPhoneNumberField(),
                                        const SizedBox(height: 10),
                                        _buildAddressField(),
                                      ],
                                    )),
                                const SizedBox(height: 5),
                                const Text(
                                  'Chi tiết đơn hàng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 108, 108, 108),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children:
                                        widget.cart.productEntries.map((item) {
                                      return Card(
                                        surfaceTintColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 4,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Image.network(
                                                item.value.imageUrl,
                                                fit: BoxFit.cover,
                                                width: 50,
                                                height: 50,
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      item.value.nameProduct
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255, 82, 82, 82),
                                                      ),
                                                    ),
                                                    Text(
                                                      '${item.value.quantity} x ${NumberFormat.decimalPattern().format(item.value.price)}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Color.fromARGB(
                                                            255, 158, 81, 81),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Tổng: ${NumberFormat.decimalPattern().format(widget.cart.totalAmount)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 0, 62, 113)),
                                      ),
                                      const SizedBox(width: 10),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          maximumSize:
                                              MaterialStateProperty.all(
                                                  Size(100, 100)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color.fromARGB(
                                                      255, 141, 0, 0)),
                                          foregroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.white),
                                        ),
                                        onPressed: () {
                                          _saveForm();
                                          
                                        },
                                        child: const Text(
                                          "Xác Nhận",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  child: const Text('ORDER NOW'))
            ],
          )),
    );
  }

  TextFormField _buildPhoneNumberField() {
    return TextFormField(
      initialValue: _inforOrderItem.phoneNumber,
      style: const TextStyle(fontSize: 10),
      decoration: const InputDecoration(
        labelText: 'Số điện thoại',
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 168, 0, 0)),
          // Màu biên khi focus
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập số điện thoại';
        }
        if (!RegExp(
                r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
            .hasMatch(value)) {
          return 'Số điện thoại không hợp lệ';
        }
        return null;
      },
      onSaved: (value) {
        _inforOrderItem = _inforOrderItem.copyWith(phoneNumber: value);
      },
    );
  }

  TextFormField _buildAddressField() {
    return TextFormField(
      initialValue: _inforOrderItem.address,
      style: const TextStyle(fontSize: 10),
      decoration: const InputDecoration(
        labelText: 'Địa chỉ',
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 168, 0, 0)),
          // Màu biên khi focus
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Vui lòng nhập địa chỉ';
        }
        return null;
      },
      onSaved: (value) {
        _inforOrderItem = _inforOrderItem.copyWith(address: value);
      },
    );
  }
}
