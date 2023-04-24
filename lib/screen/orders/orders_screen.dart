import 'package:flutter/material.dart';
import 'package:loja_virtual/common/Custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/common/empty_card.dart';
import 'package:loja_virtual/common/login_card.dart';
import 'package:provider/provider.dart';

import '../../models/orders_manager.dart';
import '../../common/order/order_tile.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: SweepGradient(
                colors: [
                  Colors.blue,
                  Colors.green,
                  Colors.yellow,
                  Colors.red,
                  Colors.blue
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1],
              ),
            ),
          ),
          Consumer<OrdersManager>(
            builder: (_, ordersManager, __) {
              if (ordersManager.user == null) {
                return const LoginCard();
              } else if (ordersManager.orders.isEmpty) {
                return const EmptyCard(
                  iconData: Icons.border_clear,
                  title: 'Nenhuma compra encontrada',
                );
              } else {
                return ListView.builder(
                  itemCount: ordersManager.orders.length,
                  itemBuilder: (_, index) {
                    return OrderTile(
                      order: ordersManager.orders.reversed.toList()[index],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
