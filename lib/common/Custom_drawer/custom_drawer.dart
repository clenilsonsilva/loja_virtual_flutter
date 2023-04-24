import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
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
          ListView(
            children: [
              const CustomDrawerHeader(),
              const Divider(),
              const DrawerTile(
                icondata: Icons.home,
                title: 'Inicio',
                page: 0,
              ),
              const DrawerTile(
                icondata: Icons.list,
                title: 'Produtos',
                page: 1,
              ),
              const DrawerTile(
                icondata: Icons.playlist_add_check,
                title: 'Meus pedidos',
                page: 2,
              ),
              const DrawerTile(
                icondata: Icons.location_on,
                title: 'Lojas',
                page: 3,
              ),
              Consumer<UserManager>(builder: (context, userManager, child) {
                if (userManager.adminEnabled) {
                  return Column(
                    children: const [
                      Divider(),
                      DrawerTile(
                        icondata: Icons.settings,
                        title: 'Usuarios',
                        page: 4,
                      ),
                      DrawerTile(
                        icondata: Icons.settings,
                        title: 'Pedidos',
                        page: 5,
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              })
            ],
          ),
        ],
      ),
    );
  }
}
