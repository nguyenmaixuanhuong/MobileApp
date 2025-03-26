import 'dart:developer';

import 'package:flutter/material.dart';
import './infor_product_screen.dart';
import '../products/products_manager.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';

class UserProductListTile extends StatelessWidget {
  final Product product;
  const UserProductListTile(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.nameProduct),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: <Widget>[
            EditUserProductButton(
              onPressed: (){
                Navigator.of(context).pushNamed(
                  InforProductScreen.routeName,
                  arguments: product.id,
                );
              },
            ),
            DeleteUserProductButton(
              onPressed: (){
                context.read<ProductsManager>().deleteProduct(product.id!);
                ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text(
                    'Product deleted',
                    textAlign: TextAlign.center,
                  ))
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class DeleteUserProductButton extends StatelessWidget {
  final void Function()? onPressed;
  const DeleteUserProductButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      onPressed: onPressed,
      color: Theme.of(context).colorScheme.error,
    );
  }
}

class EditUserProductButton extends StatelessWidget {
  final void Function()? onPressed;
  const EditUserProductButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(Icons.edit),
      color: Theme.of(context).colorScheme.primary,
    );
  }
}
