import 'package:flutter/material.dart';

import '../../../models/product.dart';

class ProductsListTile extends StatelessWidget {
  const ProductsListTile({super.key, required this.product});

  final Product product;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Container(
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Image.network(product.images.first),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'A partir de',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    'R\$ ${product.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (!product.hasStock)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Sem Estoque',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
