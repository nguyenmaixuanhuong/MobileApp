import 'package:flutter/foundation.dart';

class Product {
  final String? id;
  final String nameCategory;
  final String nameProduct;
  final String description;
  final int price;
  final String imageUrl;
  final ValueNotifier<bool> _isFavorite;

  Product({
    this.id,
    required this.nameCategory,
    required this.nameProduct,
    required this.description,
    required this.price,
    required this.imageUrl,
    isFavorite = false,
  }) : _isFavorite = ValueNotifier(isFavorite);

set isFavorite( bool newValue ) {
  _isFavorite.value = newValue;
}

bool get isFavorite {
  return _isFavorite.value;
}

ValueNotifier<bool> get isFavoriteListenable {
  return _isFavorite;
}
  Product copyWith({
    String? id,
    String? nameCategory,
    String? nameProduct,
    String? description,
    int? price,
    String? imageUrl,
    bool? isFavorite
  }){
    return Product(
      id: id ?? this.id,
      nameCategory: nameCategory ?? this.nameCategory,
      nameProduct: nameProduct ?? this.nameProduct,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String , dynamic> toJson() {
    return {
      "nameProduct": nameProduct,
      "description": description,
      "nameCategory": nameCategory,
      "price": price,
      "imageUrl": imageUrl,
    };
  }

  static Product fromJson(Map <String, dynamic> json) {
    return Product (
      id: json["id"],
      nameProduct: json["nameProduct"],
      nameCategory: json["nameCategory"],
      description: json["description"],
      price: json["price"],
      imageUrl: json["imageUrl"],
    );
  }
}