import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../models/section_item.dart';

class ItemTile extends StatelessWidget {
  const ItemTile({super.key, required this.item});

  final SectionItem item;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item.product != null) {
          final product =
              context.read<ProductManager>().findProductByID(item.product!);
          if (product != null) {
            Navigator.of(context).pushNamed('/product', arguments: product);
          }
        }
      },
      child: item.image is String
          ? FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: item.image,
              fit: BoxFit.cover,
            )
          : Image.file(item.image, fit: BoxFit.cover,),
    );
  }
}
