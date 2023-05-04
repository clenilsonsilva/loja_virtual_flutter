import 'package:flutter/material.dart';

import 'notification_page.dart';

class Routes {
  static Map<String, Widget Function(BuildContext)> list = <String, WidgetBuilder> {
    '/notification': (_) => const NotificationPage(),
  };
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}