import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:flutter/material.dart';
import '../listscreen.dart';
import 'package:provider/provider.dart';
import '../products/products_manager.dart';
import './user_product_list_tile.dart';
class AdminProductsScreen extends StatelessWidget {
  static const routeName = '/admin-products';
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm', style: TextStyle(fontSize: 16),),
        actions: <Widget>[
          IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                  context.read<AuthManager>().logout();
                },
                icon: const Icon(Icons.logout)),
        ],
      ),
      body: FutureBuilder(
        future: context.read<ProductsManager>().fetchUserProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: () =>
                context.read<ProductsManager>().fetchUserProducts(),
            child: const UserProductList(),
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
        tooltip: 'Thêm sản phẩm mới',
        mini :true,
          onPressed: () {
           Navigator.of(context).pushNamed(
                InforProductScreen.routeName,
              );
          },
          child:  const Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 53, 176, 238),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class UserProductList extends StatelessWidget {
  const UserProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsManager>(builder: (ctx, productsManager, child) {
      return ListView.builder(
        itemCount: productsManager.itemCount,
        itemBuilder: (context, index) => Column(
          children: [
            UserProductListTile(
              productsManager.items[index],
            ),
            const Divider(),
          ],
        ),
      );
    });
  }
}
