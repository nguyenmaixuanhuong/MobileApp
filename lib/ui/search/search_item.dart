import 'package:ct484_project/models/product.dart';
import 'package:flutter/material.dart';

import '../products/product_detail_screen.dart';
class SearchItem extends StatelessWidget {
  const SearchItem( this.product,  {super.key});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: () {
         Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
      },
      child: Card(
        surfaceTintColor:  Color.fromARGB(255, 255, 255, 255),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 20,),
               Column(           
                  crossAxisAlignment: CrossAxisAlignment.start,   
                  children: <Widget>[
                    Text(product.nameProduct,
                      style: const TextStyle(
                          fontWeight:FontWeight.w500,
                          color: Color.fromARGB(255, 82, 82, 82)
                      )  ,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('Giá: ${product.price}',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 119, 148)
                        ),
                      ),
                    ),
                  ],
                ), 
            ],
          ),
        ),
      ),
    );
  }
}