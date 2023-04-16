import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order.dart';
import 'user.dart';

class AdminOrdersManager extends ChangeNotifier {
  List<Orderr> _orders = [];

  Userr? userFilter;

  final firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  void updateAdmin(bool adminEnabled) {
    _orders.clear();

    if (adminEnabled) {
      _listenToOrders();
    }
  }

  List<Orderr> get filteredOrders {
    List<Orderr> output = _orders.reversed.toList();
    if (userFilter != null) {
      output = output.where((o) => o.userId == userFilter?.id).toList();
    }
    return output;
  }

  void _listenToOrders() {
    _subscription = firestore.collection('orders').snapshots().listen(
      (event) {
        for (final change in event.docChanges) {
          switch (change.type) {
            case DocumentChangeType.added:
              _orders.add(Orderr.fromDocument(change.doc));
              break;
            case DocumentChangeType.modified:
              final modOrder =
                  _orders.firstWhere((o) => o.orderId == change.doc.id);
              modOrder.updateFromDocument(change.doc);
              break;
            case DocumentChangeType.removed:
              debugPrint('Problema');
              break;
          }
        }
        notifyListeners();
      },
    );
  }

  void setUserFilter(Userr? user) {
    userFilter = user;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
