import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/gradient.dart';
import '../../models/product_manager.dart';

class SelectProductScreen extends StatelessWidget {
  const SelectProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vincular Produto'),
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Gradientt(),
          Consumer<ProductManager>(
            builder: (context, productManager, child) {
              return ListView.builder(
                  itemCount: productManager.allProducts.length,
                  itemBuilder: (_, index) {
                    final product = productManager.allProducts[index];
                    return ListTile(
                      leading: Image.network(product.images.first),
                      title: Text(product.name),
                      subtitle:
                          Text('R\$ ${product.basePrice.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.of(context).pop(product);
                      },
                    );
                  });
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
