import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../common/empty_card.dart';
import '../../models/admin_orders_manager.dart';
import '../../common/order/order_tile.dart';

class AdminOrdersScrren extends StatelessWidget {
  const AdminOrdersScrren({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return Column(
            children: [
              if (ordersManager.userFilter != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Pedidos de ${ordersManager.userFilter?.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CustomIconButton(
                        iconData: Icons.close,
                        color: Colors.white,
                        ontap: () {
                          ordersManager.setUserFilter(null);
                        },
                      ),
                    ],
                  ),
                ),
              filteredOrders.isEmpty
                  ? const Expanded(
                    child: EmptyCard(
                        iconData: Icons.border_clear,
                        title: 'Nenhuma Venda realizada',
                      ),
                  )
                  : Expanded(
                    child: ListView.builder(
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, index) {
                          return OrderTile(
                            showControls: true,
                            order: filteredOrders[index],
                          );
                        },
                      ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
