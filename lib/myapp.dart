import 'package:flutter/material.dart';
import 'package:loja_virtual/models/admin_orders_manager.dart';
import 'package:provider/provider.dart';

import 'models/admin_users_manager.dart';
import 'models/cart_manager.dart';
import 'models/home_manager.dart';
import 'models/order.dart';
import 'models/orders_manager.dart';
import 'models/product.dart';
import 'models/product_manager.dart';
import 'models/user_manager.dart';
import 'screen/address/address_screen.dart';
import 'screen/base/base_screen.dart';
import 'screen/cart/cart_screen.dart';
import 'screen/checkout/checkout_screen.dart';
import 'screen/confirmation/confirmation_screen.dart';
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
        ChangeNotifierProxyProvider<UserManager, OrdersManager>(
            create: (_) => OrdersManager(),
            lazy: false,
            update: (_, userManager, ordersManager) =>
                ordersManager!..updateUser(userManager.usuario)),
        ChangeNotifierProxyProvider<UserManager, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager!..updateUser(userManager),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserManager, AdminUsersManager>(
          create: (_) => AdminUsersManager(),
          lazy: false,
          update: (_, userManager, adminUsersManager) =>
              adminUsersManager!..updateUser(userManager),
        ),
        ChangeNotifierProxyProvider<UserManager, AdminOrdersManager>(
          create: (_) => AdminOrdersManager(),
          lazy: false,
          update: (_, userManager, adminOrdersManager) =>
              adminOrdersManager!..updateAdmin(userManager.adminEnabled),
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
            case '/confirmation':
              return MaterialPageRoute(builder: (_) => ConfirmationScreen(order: settings.arguments as Orderr));
            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => const CartScreen(), settings: settings);
            case '/checkout':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());
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
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(), settings: settings);
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
