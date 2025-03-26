import 'package:ct484_project/ui/listscreen.dart';
import 'package:ct484_project/ui/products/product_grid.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:ct484_project/ui/share/navigate_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth_manager.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedImage = 3;
  final _nameCategory = ValueNotifier<String>('');
  bool selected = false;

  late Future<void> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 162, 0, 0),
          foregroundColor: Colors.white,
          // automaticallyImplyLeading: false,
          actions: <Widget>[
            const ShoppingCartButton(),
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                  context.read<AuthManager>().logout();
                },
                icon: const Icon(Icons.logout)),
          ],
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  expandedHeight: 200,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/image/poster.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverPersistentHeaderDelegate(
                    child: Container(
                      height: 80,
                      color: Colors.white,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircularImage(
                                imagePath: 'assets/image/ring.png',
                                isSelected: selectedImage == 0,
                                onTap: () {
                                  if (selectedImage != 0) {
                                    selected = !selected;
                                    setState(() {
                                      selectedImage = 0;
                                      _nameCategory.value = 'Nhẫn';
                                    });
                                  } else {
                                    selected = !selected;
                                    print(selected);
                                    if (selected) {
                                      _nameCategory.value = 'Nhẫn';
                                      setState(() {
                                        selectedImage = 0;
                                      });
                                    } else {
                                      setState(() {
                                        _nameCategory.value = '';
                                        selectedImage = 3;
                                      });
                                    }
                                  }
                                },
                              ),
                              CircularImage(
                                imagePath: 'assets/image/necklace.png',
                                isSelected: selectedImage == 1,
                                onTap: () {
                                  if (selectedImage != 1) {
                                    selected = !selected;
                                    setState(() {
                                      selectedImage = 1;
                                      _nameCategory.value = 'Dây chuyền';
                                    });
                                  } else {
                                    selected = !selected;
                                    if (selected) {
                                      _nameCategory.value = 'Dây chuyền';
                                      setState(() {
                                        selectedImage = 1;
                                      });
                                    } else {
                                      setState(() {
                                        _nameCategory.value = '';
                                        selectedImage = 3;
                                      });
                                    }
                                  }
                                },
                              ),
                              CircularImage(
                                imagePath: 'assets/image/bangle.png',
                                isSelected: selectedImage == 2,
                                onTap: () {
                                  if (selectedImage != 2) {
                                    selected = !selected;
                                    setState(() {
                                      selectedImage = 2;
                                      _nameCategory.value = 'Vòng';
                                    });
                                  } else {
                                    selected = !selected;
                                    if (selected) {
                                      _nameCategory.value = 'Vòng';
                                      setState(() {
                                        selectedImage = 2;
                                      });
                                    } else {
                                      setState(() {
                                        _nameCategory.value = '';
                                        selectedImage = 3;
                                      });
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: FutureBuilder(
              future: _fetchProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return ValueListenableBuilder<String>(
                      valueListenable: _nameCategory,
                      builder: (context, onlyCategory, child) {
                        return ProductGrid(onlyCategory, false);
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
            ));
  }
}

class CircularImage extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  final Function onTap;

  const CircularImage({
    super.key,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<CircularImage> createState() => _CircularImageState();
}

class _CircularImageState extends State<CircularImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: Container(
        width: widget.isSelected ? 60 : 50,
        height: widget.isSelected ? 60 : 50,
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.isSelected
                ? Color.fromARGB(255, 150, 69, 15)
                : Colors.transparent,
            width: 3,
          ),
        ),
        padding: EdgeInsets.all(3),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.asset(
            widget.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverPersistentHeaderDelegate({
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
