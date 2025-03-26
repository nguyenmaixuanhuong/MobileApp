import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../models/order_item.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem order;

  const OrderItemCard(this.order, {super.key});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(10),
        child: ListTile(
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          title: Text('${NumberFormat.decimalPattern().format(widget.order.amount)}'),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: const Icon(Icons.pending_sharp),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Center(
                      child: Text( 'Chi tiết đơn hàng',
                      ),
                    ),
                    content: SizedBox(
                      width: 300, // Đặt chiều rộng mong muốn
                      height: widget.order.productCount * 50.0 + 80, // Đặt chiều cao mong muốn
                      child: OrderItemList(widget.order),
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}

class OrderItemList extends StatelessWidget {
  const OrderItemList(this.order, {super.key});
  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      height: min(order.productCount * 100.0 + 10, 100),
      child: ListView(
          children: order.products
              .map((prod) => Card(
                    surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
                    // margin: const EdgeInsets.symmetric(
                    //   horizontal: 15,
                    //   vertical: 4,
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.network(
                            prod.imageUrl,
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  prod.nameProduct.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 82, 82, 82)),
                                      
                                ),
                                Text(
                                  '${prod.quantity} x ${NumberFormat.decimalPattern().format(prod.price)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Color.fromARGB(255, 158, 81, 81)),
                                ),
                                SizedBox(height: 10,),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Thành tiền:  ${NumberFormat.decimalPattern().format(prod.price * prod.quantity)}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                        color:
                                            Color.fromARGB(255, 0, 119, 148)),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
              .toList()),
    );
  }
}
