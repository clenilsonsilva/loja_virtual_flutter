import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order.dart';
import 'user.dart';

class OrdersManager extends ChangeNotifier {
  Userr? user;
  List<Orderr> orders = [];

  final firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  void updateUser(Userr? user) {
    this.user = user;
    orders.clear();
    _subscription?.cancel();

    if (user != null) {
      _listenToOrders();
    }
  }

  void _listenToOrders() {
    _subscription = firestore
        .collection('orders')
        .where(
          'user',
          isEqualTo: user?.id,
        )
        .snapshots()
        .listen(
      (event) {
        orders.clear();
        for (final doc in event.docs) {
          orders.add(Orderr.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
