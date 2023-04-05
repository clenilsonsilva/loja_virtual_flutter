import 'package:flutter/material.dart';
import 'package:loja_virtual/screen/home/components/item_tile.dart';

import '../../../models/section.dart';
import 'section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList({super.key, required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 150,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return AspectRatio(
                      aspectRatio: 1,
                      child: ItemTile(item: section.items[index]));
                },
                separatorBuilder: (_, __) => const SizedBox(width: 20),
                itemCount: section.items.length),
          )
        ],
      ),
    );
  }
}
