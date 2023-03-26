import 'package:flutter/material.dart';
import 'package:loja_virtual/common/Custom_drawer/drawer_tile.dart';

class CustomDrawer extends StatelessWidget{
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          DrawerTile(icondata: Icons.home, title: 'Inicio', page: 0,),
          DrawerTile(icondata: Icons.list, title: 'Produtos', page: 1,),
          DrawerTile(icondata: Icons.playlist_add_check, title: 'Meus pedidos', page: 2,),
          DrawerTile(icondata: Icons.location_on, title: 'Lojas', page: 3,),
        ],
      ),
    );
  }

}