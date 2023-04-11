import 'package:flutter/material.dart';
import 'package:loja_virtual/models/home_manager.dart';
import 'package:provider/provider.dart';

import '../../common/Custom_drawer/custom_drawer.dart';
import '../../models/user_manager.dart';
import 'components/add_section_widget.dart';
import 'components/section_list.dart';
import 'components/section_stagerred.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 211, 118, 130),
                  Color.fromRGBO(168, 146, 140, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Clenilson'),
                  centerTitle: true,
                ),
                actions: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                  ),
                  Consumer2<UserManager, HomeManager>(
                    builder: (context, userManager, homeManager, child) {
                      if (userManager.adminEnabled) {
                        if (homeManager.editing) {
                          return PopupMenuButton(onSelected: (e) {
                            if (e == 'Salvar') {
                              homeManager.saveEditing();
                            } else {
                              homeManager.discardEditing();
                            }
                          }, itemBuilder: (_) {
                            return ['Salvar', 'Descartar'].map((e) {
                              return PopupMenuItem(
                                value: e,
                                child: Text(e),
                              );
                            }).toList();
                          });
                        } else {
                          return IconButton(
                            onPressed: homeManager.enterEditing,
                            icon: const Icon(Icons.edit),
                          );
                        }
                      } else {
                        return const SizedBox();
                      }
                    },
                  )
                ],
              ),
              Consumer<HomeManager>(
                builder: (context, homeManager, child) {
                  final List<Widget> children =
                      homeManager.sections.map<Widget>(
                    (section) {
                      switch (section.type) {
                        case 'List':
                          return SectionList(section: section);
                        case 'Stagerred':
                          return SectionStagerred(section: section);
                        default:
                          return Container();
                      }
                    },
                  ).toList();
                  if (homeManager.editing) {
                    children.add(const SizedBox(height: 20));
                    children.add(AddSectionWidget(homeManager: homeManager));
                  }
                  return SliverList(
                      delegate: SliverChildListDelegate(children));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
