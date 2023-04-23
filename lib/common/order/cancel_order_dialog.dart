import 'package:flutter/material.dart';

import '../../models/order.dart';

class CancelOrderDialog extends StatefulWidget {
  const CancelOrderDialog({super.key, required this.order});

  final Orderr order;

  @override
  State<CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends State<CancelOrderDialog> {
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        title: Text('Cancelar ${widget.order.formattedId}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loading ? 'Cancelando...' : 'Esta ação não pode ser desfeita!',
              style: TextStyle(
                color: loading ? Colors.red : Colors.black,
              ),
            ),
            if (error.isNotEmpty) Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(error, style: const TextStyle(color: Colors.red),),
            )
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: !loading
                ? () {
                    Navigator.of(context).pop();
                  }
                : null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor),
            child: const Text(
              'Voltar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: !loading
                ? () async {
                    setState(() {
                      loading = true;
                    });
                    try {
                      await widget.order.cancel();
                      Navigator.of(context).pop();
                    } catch (e) {
                      setState(() {
                        loading = false;
                        error = "$e";
                      });
                    }
                  }
                : null,
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
