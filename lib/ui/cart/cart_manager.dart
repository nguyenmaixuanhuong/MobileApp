import 'package:ct484_project/models/auth_token.dart';
import 'package:ct484_project/models/product.dart';
import 'package:ct484_project/services/cart_service.dart';
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';

class CartManager with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final CartService _cartService;
  CartManager([AuthToken? authToken]) : _cartService = CartService(authToken);

  set authToken(AuthToken? authToken) {
    _cartService.authToken = authToken;
  }

  Future<void> fetchCartItems() async {
    _items = await _cartService.fetchCartItems();
    notifyListeners();
  }

  Future<void> fetchUserProducts() async {
    _items = await _cartService.fetchCartItems(filtereByUser: true);
    notifyListeners();
  }

  int get productCount {
    return _items.length;
  }

  List<CartItem> get products {
    return _items.values.toList();
  }

  Iterable<MapEntry<String, CartItem>> get productEntries {
    return {..._items}.entries;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  Future<void> addItem(Product product, int number) async {
    if (_items.containsKey(product.id)) {
      CartItem? existingCartItem = _items[product.id];
      if (existingCartItem != null) {
        CartItem item = existingCartItem.copyWith(
          quantity: existingCartItem.quantity + number,
        );
        if (await _cartService.updateCartItem(item)) {
          _items.update(
            product.id!,
            (existingCartItem) => existingCartItem.copyWith(
              quantity: existingCartItem.quantity + number,
            ),
          );
        }
      }
    } else {
      CartItem newCartItem = CartItem(
          id: product.id,
          nameProduct: product.nameProduct,
          imageUrl: product.imageUrl,
          quantity: number,
          price: product.price);
      final addedCartItem = await _cartService.addToCart(newCartItem);
      if (addedCartItem != null) {
        _items.putIfAbsent(
          product.id!,
          () => addedCartItem,
        );
      }
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]?.quantity as num > 1) {
      _items.update(
        productId,
        (existingCartItem) => existingCartItem.copyWith(
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearItem(String productId) async {
    if (await _cartService.deleteCartItem(productId)) {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearAllItems() async {
    if (await _cartService.deleteAllCartItem()) {
      _items = {};
    }
    notifyListeners();
  }
}
