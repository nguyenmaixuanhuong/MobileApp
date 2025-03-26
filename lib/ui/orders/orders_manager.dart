import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/services/order_service.dart';
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../models/order_item.dart';

class OrdersManager with ChangeNotifier {
  List<OrderItem> _orders = [];

  final OrderService _orderService;

  OrdersManager([AuthToken? authToken])
    :_orderService = OrderService(authToken);

  set authToken(AuthToken? authToken){
    _orderService.authToken = authToken;
  }
  int get orderCount {
    return _orders.length;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrderItems() async {
    _orders = await _orderService.fetchOrderItems();
    notifyListeners();
  }

   Future<void> addOrder(OrderItem inforOrder) async {
    OrderItem orderItem = OrderItem(
      id: 'o${DateTime.now().toIso8601String()}',
      amount: inforOrder.amount,
      products: inforOrder.products,
      dateTime: DateTime.now(),
      phoneNumber: inforOrder.phoneNumber,
      address: inforOrder.address,
    );

    final newOrder = await _orderService.addToOrder(orderItem);
    if (newOrder != null) {
      _orders.insert(0,newOrder);
      notifyListeners();
    }
    notifyListeners();
  }
}
