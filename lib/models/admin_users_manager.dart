import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user.dart';
import 'user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  List<Userr> users = [];

  final firestore = FirebaseFirestore.instance;

  StreamSubscription? _subscription;

  void updateUser(UserManager user) {
    _subscription?.cancel();
    if (user.adminEnabled) {
      _listenToUsers();
    }
    else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription = firestore.collection('users').snapshots().listen((snapShot) { 
      users = snapShot.docs.map((d) => Userr.fromDocument(d)).toList();
      users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.name).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
