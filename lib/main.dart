import 'dart:developer';
import 'package:ct484_project/ui/cart/cart_manager.dart';
import 'package:ct484_project/ui/orders/orders_manager.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ct484_project/ui/auth/auth_manager.dart';
import 'package:lottie/lottie.dart';
import 'ui/listscreen.dart';
import 'package:provider/provider.dart';
Future<void> main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 150, 13, 0),
      secondary: const Color.fromARGB(255, 198, 103, 2),
      background: Colors.white,
      surfaceTint: const Color.fromARGB(255, 179, 21, 0),
    );
    final themeData = ThemeData(
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 162, 0, 0),
        foregroundColor: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Color.fromARGB(255, 116, 0, 0),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthManager(),
        ),
        ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
            create: (ctx) => ProductsManager(),
            update: (ctx, authManager, productsManager) {
              productsManager!.authToken = authManager.authToken;
              return productsManager;
            }),
        
        ChangeNotifierProxyProvider<AuthManager, CartManager>(
            create: (ctx) => CartManager(),
            update: (ctx, authManager, cartManager) {
              cartManager!.authToken = authManager.authToken;
              return cartManager;
            }),
          ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
            create: (ctx) => OrdersManager(),
            update: (ctx, authManager, orderManager) {
              orderManager!.authToken = authManager.authToken;
              return orderManager;
            }),
      ],
      child: Consumer<AuthManager>(builder: (ctx, authManager, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: themeData,
          home: authManager.isAuth
              ? (authManager.authToken?.email == dotenv.env['EMAIL_ADMIN'] ? 
                const SafeArea(
                  child:AdminProductsScreen())
                :
                SafeArea(
                  child: NavigationBarBottom(
                  initialPageIndex: 0,
                ))
              ) 
              : FutureBuilder(
                  future: authManager.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? SafeArea(
                            child: Lottie.network(
                              height:100,
                                'https://lottie.host/664d5ad7-d8ba-48b7-8dca-b4b506cb8926/OrSvcDYftE.json'))
                        : const SafeArea(child: AuthScreen());
                  },
                ),
          routes: {
            HomeScreen.routeName: (ctx) => const SafeArea(child: HomeScreen()),
            CartScreen.routeName: (ctx) => const SafeArea(child: CartScreen()),
            OrdersScreen.routeName: (ctx) => const SafeArea(child: OrdersScreen()),
            AdminProductsScreen.routeName: (ctx) => const SafeArea(child: AdminProductsScreen()),
          },
          onGenerateRoute: (settings) {
            if (settings.name == ProductDetailScreen.routeName) {
              final productId =
                  settings.arguments as String; // Lấy productId từ settings
              return MaterialPageRoute(builder: (context) {
                return SafeArea(
                  child: ProductDetailScreen(
                      ctx.read<ProductsManager>().findById(productId)!),
                );
              });
            }
            if (settings.name == InforProductScreen.routeName) {
              final productId = settings.arguments as String?;
              return MaterialPageRoute(
                // settings: settings,
                builder: (ctx) {
                  return SafeArea(
                    child: InforProductScreen(
                      productId != null
                          ? ctx.read<ProductsManager>().findById(productId)
                          : null,
                    ),
                  );
                },
              );
            }
          },
        );
      }),
    );
    //
  }
}
