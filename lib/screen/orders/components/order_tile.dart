import 'package:flutter/material.dart';

import '../../../models/order.dart';
import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({super.key, required this.order});

  final Orderr order;

  @override
  Widget build(BuildContext context) {
    final pc = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.formattedId,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: pc,
                  ),
                ),
                Text(
                  'R\$ ${order.price?.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Text(
              'Em transporte',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: pc,
                fontSize: 14,
              ),
            ),
          ],
        ),
        children: [
          Column(
            children: order.items!.map((e) {
              return OrderProductTile(cartProduct: e);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
