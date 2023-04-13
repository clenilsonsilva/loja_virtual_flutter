import 'package:flutter/material.dart';

import '../../../models/home_manager.dart';
import '../../../models/section.dart';

class AddSectionWidget extends StatelessWidget {
  const AddSectionWidget({super.key, required this.homeManager});

  final HomeManager homeManager;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  homeManager.addSection(Section(items: [], type: 'List'));
                },
                child: const SizedBox(
                  child: Text(
                    'Adicionar Lista',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  homeManager.addSection(Section(items: [], type: 'Stagerred'));
                },
                child: const SizedBox(
                  child: Text('Adicionar Grade',
                  textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      )),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
