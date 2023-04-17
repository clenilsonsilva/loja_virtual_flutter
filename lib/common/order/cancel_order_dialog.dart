import 'package:flutter/material.dart';

import '../../models/order.dart';

class CancelOrderDialog extends StatelessWidget {
  const CancelOrderDialog({super.key, required this.order});

  final Orderr order;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cancelar ${order.formattedId}'),
      content: const Text('Esta ação não pode ser desfeita!'),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: () {
            order.cancel();
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar', style: TextStyle(color: Colors.white, fontSize: 16),),
        ),
      ],
    );
  }
}
