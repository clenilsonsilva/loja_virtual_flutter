import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/page_manager.dart';
import '../login/login_screen.dart';
import '../products/products_screen.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({super.key});
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => PageManager(pageController),
      child: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // LoginScreen(),
          Scaffold(
            drawer:  const CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home2'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          const ProductsScreen(),
          Scaffold(
            drawer:  const CustomDrawer(),
            appBar: AppBar(
              title: const Text('Home4'),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          
        ],
      ),
    );
  }
}
