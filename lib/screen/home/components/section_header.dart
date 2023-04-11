import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';
import 'package:provider/provider.dart';

import '../../../models/home_manager.dart';
import '../../../models/section.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key,});
  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<Section>();
    if (homeManager.editing) {
      return Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: section.name,
              decoration: const InputDecoration(
                hintText: 'Titulo',
                isDense: true,
                border: InputBorder.none,
              ),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
              onChanged: (text) => section.name = text,
            ),
          ),
          CustomIconButton(
            iconData: Icons.remove,
            color: Colors.white,
            ontap: () {
              homeManager.removeSection(section);
            },
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      );
    }
  }
}
