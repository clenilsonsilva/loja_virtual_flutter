import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:provider/provider.dart';

import '../../models/cart_manager.dart';
import '../../models/ckeckout_manager.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager?>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager?..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: ListView(
          children: [
            PriceCard(
              buttonText: 'Finalizar Pedido',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
