import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'store.dart';

class StoresManager extends ChangeNotifier{

  StoresManager() {
    _loadStoreList();
  }

  List<Store> stores = [];

  final firestore = FirebaseFirestore.instance;
  Future<void> _loadStoreList() async {
    final snapShot = await firestore.collection('stores').get();
    stores = snapShot.docs.map((e) => Store.fromDocument(e)).toList();
    notifyListeners();
  }
}