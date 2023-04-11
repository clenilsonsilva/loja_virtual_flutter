import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loja_virtual/screen/edit_product/components/image_source_sheet.dart';
import 'package:provider/provider.dart';

import '../../../models/section.dart';
import '../../../models/section_item.dart';

class AddTileWidget extends StatelessWidget {
  const AddTileWidget({super.key});


  @override
  Widget build(BuildContext context) {
    final section = context.watch<Section>();
    void onImageSelected(File file) {
      section.addItem(SectionItem(file, null));
      Navigator.of(context).pop();
    }
    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(context: context, builder: (context) => ImageSourceSheet(onImageSelected: onImageSelected));
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
