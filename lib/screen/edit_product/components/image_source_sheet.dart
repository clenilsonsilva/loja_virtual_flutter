import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({super.key, required this.onImageSelected});

  final Function(File) onImageSelected;

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String path) async {
      final croppedFile = await ImageCropper.platform.cropImage(
          sourcePath: path,
          aspectRatio: const CropAspectRatio(
            ratioX: 1.0,
            ratioY: 1.0,
          ),
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Theme.of(context).primaryColor,
              toolbarTitle: 'Editar Imagem',
              toolbarWidgetColor: Colors.white,
            )
          ]);
      if(croppedFile!=null) {
        onImageSelected(File(croppedFile.path));
      }
    }

    return BottomSheet(
        onClosing: () {},
        builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? file =
                        await picker.pickImage(source: ImageSource.camera);
                    editImage(file?.path ?? '');
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Text(
                      'Camera',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Divider(),
                GestureDetector(
                  onTap: () async {
                    final XFile? file =
                        await picker.pickImage(source: ImageSource.gallery);
                    editImage(file?.path ?? '');
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Text(
                      'Galeria',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ));
  }
}
