import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:loja_virtual/screen/home/components/item_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/section.dart';
import 'add_tile_widget.dart';
import 'section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: section,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(),
            SizedBox(
                height: 150,
                child: Consumer<Section>(
                  builder: (context, section, child) {
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          if (index < section.items.length) {
                            return AspectRatio(
                                aspectRatio: 1,
                                child: ItemTile(item: section.items[index]));
                          } else {
                            return const AddTileWidget();
                          }
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 20),
                        itemCount: homeManager.editing
                            ? section.items.length + 1
                            : section.items.length);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
