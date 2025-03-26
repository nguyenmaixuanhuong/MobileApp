class CartItem {
  final String? id;
  final String nameProduct;
  final String imageUrl;
  final int quantity;
  final int price;

  CartItem ({
    required this.id,
    required this.nameProduct,
    required this.imageUrl,
    required this.quantity,
    required this.price
  });

  CartItem copyWith ({
    String? id,
    String? nameProduct,
    String? imageUrl,
    int? quantity,
    int? price,
  }) {
    return CartItem(
      id: id ?? this.id,
      nameProduct: nameProduct ?? this.nameProduct,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }


    Map<String , dynamic> toJson() {
    return {
      "id": id,
      "nameProduct": nameProduct,
      "quantity": quantity,
      "price": price,
      "imageUrl": imageUrl,
    };
  }

  static CartItem fromJson(Map <String, dynamic> json) {
    return CartItem (
      id: json["id"],
      nameProduct: json["nameProduct"],
      quantity: json["quantity"],
      price: json["price"],
      imageUrl: json["imageUrl"],
    );
  }

}