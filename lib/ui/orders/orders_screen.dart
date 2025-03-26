import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import './orders_manager.dart';
import './order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Future<void> _fetchOrderItems;

  @override
  void initState() {
    super.initState();
    _fetchOrderItems = context.read<OrdersManager>().fetchOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Đơn hàng của bạn',
          style: TextStyle(
            fontSize: 16
          ),
          ),
        ),
        body: Consumer<OrdersManager>(builder: (ctx, ordersManager, child) {
          return FutureBuilder(
              future: _fetchOrderItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                      itemCount: ordersManager.orderCount,
                      itemBuilder: (ctx, i) =>
                          OrderItemCard(ordersManager.orders[i]));
                }
                return Center(
                    child: Lottie.network(
                        'https://lottie.host/664d5ad7-d8ba-48b7-8dca-b4b506cb8926/OrSvcDYftE.json'));
              });
        }));
  }
}
