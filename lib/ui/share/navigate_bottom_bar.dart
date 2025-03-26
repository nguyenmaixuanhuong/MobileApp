import 'package:flutter/material.dart';
import '../listscreen.dart';

class NavigationBarBottom extends StatefulWidget {
  static const routeName = '/';
  final int initialPageIndex;

  NavigationBarBottom({Key? key, required this.initialPageIndex})
      : super(key: key);

  @override
  @override
  State<NavigationBarBottom> createState() => _NavigationBarBottomState();
}

class _NavigationBarBottomState extends State<NavigationBarBottom> {
  late int currentPageIndex;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = Theme.of(context);
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentPageIndex,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
              });
              // if (currentPageIndex == 2) {
              //    Navigator.of(context).pushNamed(OrdersScreen.routeName);
              // }
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite), // Icon for favorite
                label: 'Favorite', // Label for favorite
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.library_books),
                label: 'Order',
              ),
                BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Order',
              ),
            ],
            selectedItemColor: const Color.fromARGB(255, 167, 0, 0),
            selectedIconTheme: const IconThemeData(
              size: 24, // Kích thước của biểu tượng khi được chọn
              color: Color.fromARGB(255, 167, 0, 0),
            ),
            selectedFontSize: 10,
            unselectedItemColor: const Color.fromARGB(203, 188, 188, 188)),
        body: IndexedStack(
          index: currentPageIndex,
          children: const [
            HomeScreen(),
            ProductsFavoriteScreen(),
            OrdersScreen(),
            SearchScreen()
            // MessagesPage(),
          ],
        ));
  }
}
