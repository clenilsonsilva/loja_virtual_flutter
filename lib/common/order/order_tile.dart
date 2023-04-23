import 'package:flutter/material.dart';

import '../../models/order.dart';
import 'cancel_order_dialog.dart';
import 'export_address_dialog.dart';
import 'order_product_tile.dart';

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    this.showControls = false,
  });

  final Orderr order;

  final bool showControls;

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
              order.statusText ?? '',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: order.status == Status.canceled ? Colors.red : pc,
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
          if (showControls && order.status != Status.canceled)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, elevation: 0),
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CancelOrderDialog(order: order));
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        disabledBackgroundColor: Colors.transparent),
                    onPressed: order.back,
                    child: const Text(
                      'Recuar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        disabledBackgroundColor: Colors.transparent),
                    onPressed: order.advance,
                    child: const Text(
                      'Avançar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        disabledBackgroundColor: Colors.transparent),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => ExportAddressDialog(address: order.address));
                    },
                    child: Text(
                      'Endereço',
                      style: TextStyle(
                        color: pc,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
