import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/price_card.dart';
import '../../models/cart_manager.dart';
import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<CartManager>(
        builder: (context, cartManager, child) {
          return ListView(
            children: [
              Column(
                  children: cartManager.items
                      .map((cartProduct) => CartTile(
                            cartProduct: cartProduct,
                          ))
                      .toList()),
              PriceCard(
                buttonText: 'Continuar para Entrega',
                onPressed: cartManager.isCartValid ? () {} : null
              ),
            ],
          );
        },
      ),
    );
  }
}
