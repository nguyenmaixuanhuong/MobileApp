import 'dart:convert';
import '../models/order_item.dart';
import '../models/product.dart';
import '../models/auth_token.dart';
import './firebase_service.dart';

class OrderService extends FirebaseService {
  OrderService([AuthToken? authToken]) : super(authToken);
  
  Future<List<OrderItem>> fetchOrderItems({bool filtereByUser = false}) async {
  List<OrderItem> orderItems = [];
  
  try {
    final filters = filtereByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final ordersMap = await httpFetch('$databaseUrl/orders/$userId/.json?auth=$token&$filters') as Map<String, dynamic>?;
    ordersMap?.forEach((orderItemId, orderItem) {
      orderItems.add(
        OrderItem.fromJson({
          'id': orderItemId,
          ...orderItem,
          
        })
      );
    });


    return orderItems;
  } catch (e) {
    print(e);
    return orderItems;
  }
}


  Future<OrderItem?> addToOrder(OrderItem orderItem) async {
    try {
      final newOrderItem = await httpFetch(
        '$databaseUrl/orders/$userId.json?auth=$token',
        method: HttpMethod.post,
        body: jsonEncode(
          orderItem.toJson()
        ),
      ) as Map<String, dynamic>?;
      return orderItem.copyWith(
        id: newOrderItem!['name'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }
}