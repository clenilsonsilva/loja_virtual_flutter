import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  final firestore = FirebaseFirestore.instance;
  List<Section> _sections = [];
  List<Section> _editingSections = [];

  bool editing = false;

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen(
      (snapshot) {
        _sections.clear();
        for (final DocumentSnapshot doc in snapshot.docs) {
          _sections.add(Section.fromDocument(doc));
        }
        notifyListeners();
      },
    );
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  List<Section> get sections {
    if(editing) {
      return _editingSections;
    }
    else {
      return _sections;
    }
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  void saveEditing() {
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }
}
