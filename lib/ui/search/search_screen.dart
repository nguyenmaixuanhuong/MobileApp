import 'package:ct484_project/models/product.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:ct484_project/ui/search/search_item.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<void> _fetchProducts;
  String nameProduct = '';
  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tìm kiếm sản phẩm',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          margin: const EdgeInsets.all(16),
          child: TextField(
            onChanged: (value) => setState(() {
              nameProduct = value;
            }),
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tên sản phẩm',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.red))),
          ),
        ),
        Consumer<ProductsManager>(builder: (context, productsManager, child) {
          return FutureBuilder(
              future: _fetchProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                      child: productsManager.searchProduct(nameProduct).isNotEmpty
                          ? ListView.builder(
                              itemCount: productsManager.searchProduct(nameProduct).length,
                              itemBuilder: (context, index) =>
                                  SearchItem(productsManager.searchProduct(nameProduct)[index]))
                          :  Lottie.network(
                            width: 200,
                            'https://lottie.host/186d5f55-7182-4710-9e2b-9c0a228f99f5/hNOajC9awJ.json')
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        })
      ]),
    );
  }
}
