import 'package:flutter/material.dart';

import '../../models/product.dart';
import 'components/images_form.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Anuncio'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView(
        children: [
          ImagesForm(product: product),
        ],
      ),
    );
  }
}