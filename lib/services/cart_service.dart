import 'dart:convert';
import '../models/cart_item.dart';
import '../models/auth_token.dart';
import './firebase_service.dart';

class CartService extends FirebaseService {
  CartService([AuthToken? authToken]) : super(authToken);
  Future<Map<String, CartItem>> fetchCartItems(
      {bool filtereByUser = false}) async {
    Map<String, CartItem> cartItems = {};

    try {
      final filters =
          filtereByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final cartsMap = await httpFetch(
              '$databaseUrl/carts/$userId/.json?auth=$token&$filters')
          as Map<String, dynamic>?;

      cartsMap?.forEach((cartItemId, cartItem) {
        cartItems.addAll({
          cartItemId: CartItem.fromJson({
            'id': cartItemId,
            ...cartItem,
          })
        });
      });
      return cartItems;
    } catch (e) {
      return cartItems;
    }
  }

  Future<CartItem?> addToCart(CartItem cartItem) async {
    try {
      final newCartItem = await httpFetch(
        '$databaseUrl/carts/$userId/${cartItem.id}/.json?auth=$token',
        method: HttpMethod.patch,
        body: jsonEncode(cartItem.toJson()),
      ) as Map<String, dynamic>?;
      return cartItem.copyWith(
        id: newCartItem!['name'],
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> updateCartItem(CartItem cartItem) async {
    try {
      await httpFetch(
        '$databaseUrl/carts/$userId/${cartItem.id}/.json?auth=$token',
        method: HttpMethod.put,
        body: jsonEncode(cartItem.toJson()),
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteCartItem(String id) async {
    try {
      await httpFetch(
        '$databaseUrl/carts/$userId/$id.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

   Future<bool> deleteAllCartItem() async {
    try {
      await httpFetch(
        '$databaseUrl/carts/$userId.json?auth=$token',
        method: HttpMethod.delete,
      );
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
