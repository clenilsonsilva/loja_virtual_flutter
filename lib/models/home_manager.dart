import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'section.dart';

class HomeManager extends ChangeNotifier{
  HomeManager() {
    _loadSections();
  }

  final firestore = FirebaseFirestore.instance;
  List<Section> sections = [];

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snapshot) {
        sections.clear();
        for (final DocumentSnapshot doc in snapshot.docs) {
          sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }
}
