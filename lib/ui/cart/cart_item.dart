import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/cart_item.dart';
// import '../shared/dialog_utils.dart';

class CartItemCard extends StatelessWidget {
  final String productId;
  final CartItem cartItem;
  const CartItemCard({
    super.key,
    required this.productId,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<CartManager>().clearItem(productId);
      },
      child: ItemInfoCard(cartItem),
      
    );
  }
}

class ItemInfoCard extends StatelessWidget {
  const ItemInfoCard(this.cartItem, {super.key});
  final CartItem cartItem;
  @override
  Widget build(BuildContext context) {
    return 
    Card(
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
              cartItem.imageUrl,
              fit: BoxFit.cover,
              width: 80,
              height: 80,
            ),
            const SizedBox(width: 20,),
            Expanded(
              child: Column(         
                crossAxisAlignment: CrossAxisAlignment.start,   
                children: <Widget>[
                  Text(cartItem.nameProduct.toUpperCase(),
                    style: const TextStyle(
                        fontWeight:FontWeight.w500,
                        color: Color.fromARGB(255, 82, 82, 82)
                    )  ,
                  ),
                  Text(
                    '${cartItem.quantity} x ${NumberFormat.decimalPattern().format(cartItem.price)}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 158, 81, 81)
                    )  ,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text('Thành tiền:  ${NumberFormat.decimalPattern().format(cartItem.price* cartItem.quantity)}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 0, 119, 148)
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
