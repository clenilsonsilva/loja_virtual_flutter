import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loja_virtual/screen/home/components/add_tile_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/home_manager.dart';
import '../../../models/section.dart';
import 'item_tile.dart';
import 'section_header.dart';

class SectionStagerred extends StatelessWidget {
  const SectionStagerred({super.key, required this.section});

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
            Consumer<Section>(
              builder: (context, section, child) {
                return MasonryGridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    itemCount: homeManager.editing
                        ? section.items.length + 1
                        : section.items.length,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (_, index) {
                      if (index < section.items.length) {
                        return ItemTile(
                          item: section.items[index],
                        );
                      } else {
                        return const AddTileWidget();
                      }
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
