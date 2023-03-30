import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/product_manager.dart';
import 'components/products_list_tile.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          title: const Text('Produtos'),
          centerTitle: true,
        ),
        body: Consumer<ProductManager>(
          builder: (context, value, child) {
            return ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: value.allProducts.length,
              itemBuilder: (_, index) {
                return ProductsListTile(product: value.allProducts[index]);
              },
            );
          },
        ));
  }
}
