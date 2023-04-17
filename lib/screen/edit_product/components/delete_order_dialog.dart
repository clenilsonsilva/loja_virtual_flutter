import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../../../models/product_manager.dart';

class DeleteOrderDialgog extends StatelessWidget {
  const DeleteOrderDialgog({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Deletar Produto'),
      content: const Text('Esta ação não pode ser desfeita!'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            context.read<ProductManager>().delete(product);
            Navigator.of(context).popUntil(
                              (route) => route.settings.name == '/');
          },
          child: const Text(
            'Deletar',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
