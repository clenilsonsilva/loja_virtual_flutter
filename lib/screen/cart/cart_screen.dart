import 'package:flutter/material.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:provider/provider.dart';

import '../../common/empty_card.dart';
import '../../common/price_card.dart';
import '../../helpers/gradient.dart';
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
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const Gradientt(),
          Consumer<CartManager>(
            builder: (_, cartManager, __) {
              if (cartManager.user == null) {
                return const LoginCard();
              } else if (cartManager.items.isEmpty) {
                return const EmptyCard(
                  iconData: Icons.remove_shopping_cart,
                  title: 'Nenhum Produto no carrinho',
                );
              }
              return ListView(
                children: [
                  Column(
                    children: cartManager.items
                        .map((cartProduct) => CartTile(
                              cartProduct: cartProduct,
                            ))
                        .toList(),
                  ),
                  PriceCard(
                      buttonText: 'Continuar para Entrega',
                      onPressed: cartManager.isCartValid
                          ? () {
                              Navigator.of(context).pushNamed('/address');
                            }
                          : null),
                ],
              );
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
