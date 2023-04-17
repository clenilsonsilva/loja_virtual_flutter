import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/address.dart';

class ExportAddressDialog extends StatelessWidget {
  ExportAddressDialog({super.key, required this.address});

  final Address? address;
  final screenShotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Endereço de Entrega'),
      content: Screenshot(
        controller: screenShotController,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Text(
              '${address?.street}, ${address?.number}, ${address?.complement}\n'
              '${address?.district}\n'
              '${address?.city}/${address?.state}\n'
              '${address?.zipCode}'),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () async {
            Navigator.of(context).pop();
            await screenShotController.capture().then((Uint8List? image) async {
              await ImageGallerySaver.saveImage(image!);
            });
          },
          child: const Text('Exportar'),
        ),
      ],
    );
  }
}
