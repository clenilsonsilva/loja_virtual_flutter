import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/page_manager.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({super.key, required this.icondata, required this.title, required this.page});

  final IconData icondata;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int curPage = context.watch<PageManager>().page;
    final Color primaryColor = Theme.of(context).primaryColor;
    return InkWell(
      onTap: () {
        context.read<PageManager>().setPage(page);
      },
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Icon(
                icondata,
                size: 32,
                color: curPage == page ? Colors.white : Colors.black,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: curPage == page ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
