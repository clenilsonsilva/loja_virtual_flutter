import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:provider/provider.dart';

import '../../models/cart_manager.dart';
import '../../models/ckeckout_manager.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final formKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager?>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: formKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, child) {
            return ListView(
              children: [
                PriceCard(
                  buttonText: 'Finalizar Pedido',
                  onPressed: () {
                    checkoutManager.checkout(
                      onStockFail: (e) {
                        Navigator.of(context).popUntil(
                            (route) => route.settings.name == '/cart');
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
