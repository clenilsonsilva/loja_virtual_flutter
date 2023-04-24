import 'package:flutter/material.dart';
import 'package:loja_virtual/common/Custom_drawer/custom_drawer.dart';
import 'package:loja_virtual/models/stores_manager.dart';
import 'package:provider/provider.dart';

import 'components/store_card.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: const Text('Lojas'),
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
          Consumer<StoresManager>(
            builder: (_, storesManager, __) {
              if (storesManager.stores.isEmpty) {
                return const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                  backgroundColor: Colors.transparent,
                );
              } else {
                return ListView.builder(
                  itemCount: storesManager.stores.length,
                  itemBuilder: (_, index) {
                    return StoreCard(store: storesManager.stores[index]);
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
