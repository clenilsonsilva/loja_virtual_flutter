import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/product_manager.dart';
import '../../models/user_manager.dart';
import 'components/products_list_tile.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (context, value, child) {
            if (value.search.isEmpty) {
              return const Text('Produtos');
            } else {
              return LayoutBuilder(builder: (_, constraint) {
                return GestureDetector(
                  child: SizedBox(
                    width: constraint.biggest.width,
                    child: Text(
                      value.search,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () async {
                    final search = await showDialog(
                        context: context,
                        builder: (_) => SearchDialog(
                              initialText: value.search,
                            ));
                    if (search != null) {
                      value.search = search;
                    }
                  },
                );
              });
            }
          },
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Consumer<ProductManager>(
            builder: (context, value, child) {
              if (value.search.isEmpty) {
                return IconButton(
                  onPressed: () async {
                    final search = await showDialog(
                        context: context,
                        builder: (_) => SearchDialog(
                              initialText: value.search,
                            ));
                    if (search != null) {
                      value.search = search;
                    }
                  },
                  icon: const Icon(Icons.search),
                );
              } else {
                return IconButton(
                  onPressed: () async {
                    value.search = '';
                  },
                  icon: const Icon(Icons.close),
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (context, userManager, child) {
              if (userManager.adminEnabled) {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/edit_product');
                  },
                  icon: const Icon(Icons.add),
                );
              } else {
                return const SizedBox();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (context, value, child) {
          final filteredProducts = value.filteredProducts;
          return ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (_, index) {
              return ProductsListTile(product: filteredProducts[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
