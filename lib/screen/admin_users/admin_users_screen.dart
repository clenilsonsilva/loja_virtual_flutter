import 'package:flutter/material.dart';
import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/admin_users_manager.dart';

class AdminUsersScreen extends StatelessWidget {
  AdminUsersScreen({super.key});
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Usuarios'),
          centerTitle: true,
        ),
        body: Consumer<AdminUsersManager>(
          builder: (context, adminUserManager, child) {
            return AlphabetListScrollView(
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(
                    adminUserManager.users[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  subtitle: Text(adminUserManager.users[index].email,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, color: Colors.white)),
                );
              },
              indexedHeight: (index) => 100,
              strList: adminUserManager.names,
              showPreview: true,
            );
          },
        ));
  }
}
