import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/price_card.dart';
import '../../helpers/gradient.dart';
import '../../models/cart_manager.dart';
import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const Gradientt(),
          ListView(
            children: [
              const AddressCard(),
              Consumer<CartManager>(
                builder: (context, cartManager, child) {
                  return PriceCard(
                    buttonText: 'Continuar para o Pagamento',
                    onPressed: cartManager.isAdrressValid ? () {
                      Navigator.of(context).pushNamed('/checkout');
                    } : null,
                  );
                },
              )
            ],
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
