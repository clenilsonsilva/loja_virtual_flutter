import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../common/empty_card.dart';
import '../../helpers/gradient.dart';
import '../../models/admin_orders_manager.dart';
import '../../common/order/order_tile.dart';
import '../../models/order.dart';

class AdminOrdersScrren extends StatefulWidget {
  const AdminOrdersScrren({super.key});

  @override
  State<AdminOrdersScrren> createState() => _AdminOrdersScrrenState();
}

class _AdminOrdersScrrenState extends State<AdminOrdersScrren> {
  final panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final pc = Theme.of(context).primaryColor;
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Todos os Pedidos'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<AdminOrdersManager>(
        builder: (_, ordersManager, __) {
          final filteredOrders = ordersManager.filteredOrders;

          return SlidingUpPanel(
            controller: panelController,
            body: Stack(
              children: [
                const Gradientt(),
                Column(
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
                ),
              ],
            ),
            minHeight: 40,
            maxHeight: 250,
            panel: Column(
              children: [
                GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    height: 40,
                    child: Text(
                      'Filtros',
                      style: TextStyle(
                        color: pc,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  onTap: () {
                    panelController.isPanelClosed
                        ? panelController.open()
                        : panelController.close();
                  },
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: Status.values.map<Widget>(
                      (s) {
                        return CheckboxListTile(
                          activeColor: pc,
                          value: ordersManager.statusFilter.contains(s),
                          title: Text(Orderr.getStatusText(s) ?? ''),
                          dense: true,
                          onChanged: (v) {
                            ordersManager.setStatusFilter(s, v);
                          },
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      extendBodyBehindAppBar: true,
    );
  }
}
