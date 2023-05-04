import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../helpers/gradient.dart';
import '../../models/cart_manager.dart';
import '../../models/product.dart';
import '../../models/user_manager.dart';
import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
          appBar: AppBar(
            title: Text(product.name),
            centerTitle: true,
            actions: [
              Consumer<UserManager>(
                builder: (_, userManager, __) {
                  if (userManager.adminEnabled && product.deleted == false) {
                    return IconButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            '/edit_product',
                            arguments: product);
                      },
                      icon: const Icon(Icons.edit),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
            backgroundColor: Colors.transparent,
          ),
          body: Stack(
            children: [
              const Gradientt(),
              ListView(
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
                      height: size.height * 0.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 13),
                          ),
                        ),
                        Text(
                          'R\$ ${product.basePrice.toStringAsFixed(2)}',
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
                        if (product.deleted == true)
                          const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              'Indisponivel',
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          )
                        else ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 8),
                            child: Text(
                              'Tamanhos',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: product.sizes.map((s) {
                              return SizeWidget(size: s);
                            }).toList(),
                          ),
                        ],
                        const SizedBox(
                          height: 20,
                        ),
                        product.hasStock
                            ? Consumer2<UserManager, Product>(
                                builder: (_, userManager, product, __) {
                                  return SizedBox(
                                    height: 44,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor),
                                      onPressed:
                                          product.selectedSize.name.isEmpty
                                              ? null
                                              : () {
                                                  if (userManager.isLoggedIn) {
                                                    context
                                                        .read<CartManager>()
                                                        .addToCart(product);
                                                    Navigator.of(context)
                                                        .pushNamed('/cart');
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamed('/login');
                                                  }
                                                },
                                      child: Text(
                                        userManager.isLoggedIn
                                            ? 'Adicionar ao Carrinho'
                                            : 'Entre para Comprar',
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const SizedBox()
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          extendBodyBehindAppBar: true),
    );
  }
}
