import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../models/home_manager.dart';
import '../../../models/section.dart';
import '../../../models/section_item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item});

  final SectionItem item;
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    return GestureDetector(
      onTap: () {
        if (item.product != null && item.product!.isNotEmpty) {
          final product =
              context.read<ProductManager>().findProductByID(item.product!);
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      onLongPress: homeManager.editing
          ? () {
              showDialog(
                context: context,
                builder: (_) {
                  final Product? product;
                  item.product != null && item.product!.isNotEmpty
                      ? product = context
                          .read<ProductManager>()
                          .findProductByID(item.product!)
                      : product = null;
                  return AlertDialog(
                    title: const Text('Editar Item'),
                    content: product != null
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Image.network(product.images.first),
                            title: Text(product.name),
                            subtitle: Text(
                                'R\$ ${product.basePrice.toStringAsFixed(2)}'),
                          )
                        : null,
                    actions: [
                      SizedBox(
                        height: 30,
                        width: 50,
                        child: GestureDetector(
                          onTap: () {
                            context.read<Section>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Excluir',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          : null,
      child: item.image is String
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.image,
              fit: BoxFit.cover,
            )
          : Image.file(
              item.image,
              fit: BoxFit.cover,
            ),
    );
  }
}
