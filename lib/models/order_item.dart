import 'cart_item.dart';

class OrderItem {
  final String? id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String phoneNumber;
  final String address;

  int get productCount {
    return products.length;
  }

  OrderItem({
    this.id,
    required this.amount,
    required this.products,
    required this.phoneNumber,
    required this.address,
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  OrderItem copyWith(
      {String? id,
      double? amount,
      List<CartItem>? products,
      DateTime? dateTime,
      String? phoneNumber,
      String? address
      }
      ) {
    return OrderItem(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      products: products ?? this.products,
      dateTime: dateTime ?? this.dateTime,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "amount": amount,
      "products": products.map((product) => product.toJson()).toList(),
      "dateTime": dateTime.toIso8601String(),
      "phoneNumber": phoneNumber,
      "address":address
    };
  }

  static OrderItem fromJson(Map<String, dynamic> json) {
    List<dynamic> productsJson = json['products'] ?? [];
    List<CartItem> products = productsJson.map((productJson) {
      return CartItem.fromJson(productJson);
    }).toList();

    return OrderItem(
      id: json["id"],
      amount: json["amount"],
      products: products,
      dateTime: DateTime.parse(json["dateTime"]),
      phoneNumber: json["phoneNumber"],
      address: json["address"],
    );
  }
}
