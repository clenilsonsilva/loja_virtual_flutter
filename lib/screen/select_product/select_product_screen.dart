import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Container(
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.blue
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1],
              ),
            ),
          ),
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
