import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart_manager.dart';
import 'models/product.dart';
import 'models/product_manager.dart';
import 'models/user_manager.dart';
import 'screen/base/base_screen.dart';
import 'screen/cart/cart_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/product/product_screen.dart';
import 'screen/sign_up/signup_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //PROVIDERS
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          update: (context, userManger, cartManager) =>
              cartManager!..updateUser(userManger),
          create: (_) => CartManager(),
          lazy: false,
        ),
      ],
      //MATERIAL APP
      child: MaterialApp(
        title: 'Loja do Clenilson',
        initialRoute: '/base',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/login':
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case '/signup':
              return MaterialPageRoute(builder: (_) => SignUpScreen());
            case '/cart':
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                        product: settings.arguments as Product,
                      ));
            case '/base':
            default:
              return MaterialPageRoute(builder: (_) => BaseScreen());
          }
        },
        theme: ThemeData(
            primaryColor: const Color.fromARGB(255, 4, 125, 141),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
            appBarTheme: const AppBarTheme(elevation: 0)),
      ),
    );
  }
}
