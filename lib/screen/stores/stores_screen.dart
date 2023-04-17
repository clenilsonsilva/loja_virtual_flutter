import 'package:flutter/material.dart';
import 'package:loja_virtual/common/Custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:provider/provider.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Lojas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<StoresManager>(
        builder: (_, storesManager, __) {
          return Container();
        },
      ),
    );
  }
}
