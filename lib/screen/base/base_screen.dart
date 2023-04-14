import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/page_manager.dart';
import '../../models/user_manager.dart';
import '../admin_users/admin_users_screen.dart';
import '../home/home_screen.dart';
import '../products/products_screen.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PageManager(pageController),
      child: Consumer<UserManager>(
        builder: (context, userManager, child) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const HomeScreen(),
              const ProductsScreen(),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home3'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              Scaffold(
                drawer: const CustomDrawer(),
                appBar: AppBar(
                  title: const Text('Home4'),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              if (userManager.adminEnabled) ...[
                AdminUsersScreen(),
                Scaffold(
                  drawer: const CustomDrawer(),
                  appBar: AppBar(
                    title: const Text('Pedidos'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
