import 'package:flutter/material.dart';
import 'package:loja_virtual/common/price_card.dart';
import 'package:provider/provider.dart';

import '../../models/cart_manager.dart';
import '../../models/ckeckout_manager.dart';
import 'components/credit_card_widget.dart';

class CheckoutScreen extends StatelessWidget {
  CheckoutScreen({super.key});

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager?>(
      create: (_) => CheckoutManager(),
      update: (_, cartManager, checkoutManager) =>
          checkoutManager!..updateCart(cartManager),
      lazy: false,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Pagamento'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Consumer<CheckoutManager>(
          builder: (_, checkoutManager, child) {
            if (checkoutManager.loading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Processando o seu pagamento...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Form(
                key: formKey,
                child: ListView(
                  children: [
                    CreditCardWidget(),
                    PriceCard(
                      buttonText: 'Finalizar Pedido',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print('alou');
                          // checkoutManager.checkout(
                          //   onStockFail: (e) {
                          //     Navigator.of(context).popUntil(
                          //         (route) => route.settings.name == '/cart');
                          //   },
                          //   onSucess: (order) {
                          //     Navigator.of(context).popUntil(
                          //         (route) => route.settings.name == '/');
                          //     Navigator.of(context)
                          //         .pushNamed('/confirmation', arguments: order);
                          //   },
                          // );
                        }
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
