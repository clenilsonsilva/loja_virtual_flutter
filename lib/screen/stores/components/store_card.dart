import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/store.dart';
import 'package:map_launcher/map_launcher.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({super.key, required this.store});

  final Store store;

  Color colorForStatus(StoreStatus? status) {
    switch (status) {
      case StoreStatus.closed:
        return Colors.red;
      case StoreStatus.open:
        return const Color.fromARGB(255, 1, 161, 6);
      case StoreStatus.closing:
        return const Color.fromARGB(255, 145, 131, 8);
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    void showError() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Este dispositivo nao possui esta funcao!!!'),
        backgroundColor: Colors.red,
      ));
    }

    Future<void> openPhone() async {
      final launchUri = Uri(scheme: 'tel', path: store.cleanPhone);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        showError();
      }
    }

    Future<void> openMap() async {
      try {
        final availableMaps = await MapLauncher.installedMaps;

        // ignore: use_build_context_synchronously
        showModalBottomSheet(
            context: context,
            builder: (_) {
              return SafeArea(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final map in availableMaps)
                    ListTile(
                      onTap: () {
                        map.showMarker(
                          coords: Coords(
                            store.address!.lat!,
                            store.address!.long!,
                          ),
                          title: store.name ?? '',
                          description: store.addressText,
                        );
                        Navigator.of(context).pop();
                      },
                      title: Text(map.mapName),
                      leading: SvgPicture.asset(
                        map.icon,
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ));
            });
      } catch (e) {
        showError();
      }
    }

    final pc = Theme.of(context).primaryColor;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: Stack(
              fit: StackFit.expand,
              children: [
                store.image != null
                    ? Image.network(
                        store.image!,
                        fit: BoxFit.cover,
                      )
                    : const SizedBox(),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(8))),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      store.statusText,
                      style: TextStyle(
                        color: colorForStatus(store.status),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 140,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        store.addressText,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Text(
                        store.oppeningText,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(
                      iconData: Icons.map,
                      color: pc,
                      ontap: openMap,
                    ),
                    CustomIconButton(
                      iconData: Icons.phone,
                      color: pc,
                      ontap: openPhone,
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
