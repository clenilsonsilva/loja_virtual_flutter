import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../models/products.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            CarouselSlider(
              items: product.images
                  .map(
                    (url) => SizedBox(
                      child: Image.network(url),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                autoPlay: false,
                height: size.height*0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
