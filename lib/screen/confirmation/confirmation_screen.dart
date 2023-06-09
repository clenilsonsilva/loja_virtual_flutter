import 'package:flutter/material.dart';

import '../../helpers/gradient.dart';
import '../../models/order.dart';
import '../../common/order/order_product_tile.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.order});

  final Orderr order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Confirmado'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const Gradientt(),
          Center(
            child: Card(
              margin: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.formattedId,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'R\$ ${order.price?.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: order.items!.map((e) {
                      return OrderProductTile(cartProduct: e);
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
