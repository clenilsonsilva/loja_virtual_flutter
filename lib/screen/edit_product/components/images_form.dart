import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../models/product.dart';
import 'image_source_sheet.dart';

class ImagesForm extends StatelessWidget {
  const ImagesForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FormField<List>(
      initialValue: List.from(product.images),
      validator: (images) {
        if (images != null) {
          if (images.isEmpty) {
            return 'Insira ao menos uma imagem';
          } else {
            return null;
          }
        } else {
          return '';
        }
      },
      builder: (state) {
        void onImageSelected(File file) {
          if (file.path.isNotEmpty) {
            state.value!.add(file);
            state.didChange(state.value);
            Navigator.of(context).pop();
          }
        }

        state.hasError;

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: CarouselSlider(
                items: state.value!.map<Widget>((image) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      image.runtimeType == String
                          ? Image.network(
                              image,
                              fit: BoxFit.cover,
                            )
                          : Image.file(image as File),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {
                              state.value!.remove(image);
                              state.didChange(state.value);
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.red,
                            )),
                      )
                    ],
                  );
                }).toList()
                  ..add(Material(
                      color: Colors.grey[100],
                      child: SizedBox(
                        width: size.width,
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (_) => ImageSourceSheet(
                                      onImageSelected: onImageSelected,
                                    ));
                          },
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ))),
                options: CarouselOptions(
                    autoPlay: false,
                    height: size.height * 0.5,
                    enlargeCenterPage: false,
                    padEnds: true),
              ),
            ),
            state.hasError
                ? Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        );
      },
    );
  }
}
