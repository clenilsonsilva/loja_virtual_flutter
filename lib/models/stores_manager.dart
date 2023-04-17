import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoresManager extends ChangeNotifier{

  StoresManager() {
    _loadStoreList();
  }

  final firestore = FirebaseFirestore.instance;
  Future<void> _loadStoreList() async {
    final snapShot = await firestore.collection('stores').get();
    print(snapShot.docs.first.data());
    notifyListeners();
  }
}