import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/admin_users_manager.dart';
import 'models/cart_manager.dart';
import 'models/home_manager.dart';
import 'models/product.dart';
import 'models/product_manager.dart';
import 'models/user_manager.dart';
import 'screen/address/address_screen.dart';
import 'screen/base/base_screen.dart';
import 'screen/cart/cart_screen.dart';
import 'screen/checkout/checkout_screen.dart';
import 'screen/edit_product/edit_product_screen.dart';
import 'screen/login/login_screen.dart';
import 'screen/product/product_screen.dart';
import 'screen/select_product/select_product_screen.dart';
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
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (context, userManager, adminUsersManager) =>
              adminUsersManager!..updateUser(userManager),
        ),
      ],
      //MATERIAL APP
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
            case '/checkout':
              return MaterialPageRoute(builder: (_) => const CheckoutScreen());
            case '/address':
              return MaterialPageRoute(builder: (_) => const AddressScreen());
            case '/select_product':
              return MaterialPageRoute(
                  builder: (_) => const SelectProductScreen());
            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(
                        product: settings.arguments as Product,
                      ));
            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) =>
                      EditProductScreen(settings.arguments as Product?));
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
