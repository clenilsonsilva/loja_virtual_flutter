import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'section_item.dart';

class Section extends ChangeNotifier {
  Section({this.id = '', this.name = '', this.type = '', required this.items}) {
    originalItems = List.from(items);
  }

  Section.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'];
    type = doc['type'];
    items = (doc['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$id');
  Reference get storageRef => storage.ref().child('home/$id');

  late String id;
  late String name;
  late String type;
  late List<SectionItem> items;
  late List<SectionItem> originalItems;

  String? _error = '';
  String? get error => _error;
  set error(String? value) {
    _error = value;
    notifyListeners();
  }

  void addItem(SectionItem item) {
    items.add(item);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  Future<void> save() async {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
    };
    if (id.isEmpty) {
      final doc = await firestore.collection('home').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    for (final item in items) {
      if (item.image is File) {
        final task = storageRef.child(const Uuid().v1()).putFile(item.image);
        final snapShot = await task;
        final url = await snapShot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for (final original in originalItems) {
      if (!items.contains(original)) {
        try {
          final ref = storage.refFromURL(original.image);
          await ref.delete();
        } catch (e) {
          // TODO
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((i) => i.toMap()).toList(),
    };

    await firestoreRef.update(itemsData);
  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for (final item in items) {
      try {
        final ref = storage.refFromURL(item.image);
        await ref.delete();
      }catch (e) {
        // TODO
      }
    }
  }

  bool valid() {
    if (name.isEmpty) {
      error = 'Titulo Invalido';
    } else if (items.isEmpty) {
      error = 'Insira ao menos uma imagem';
    } else {
      error = null;
    }
    return error == null;
  }

  Section clone() {
    return Section(
      id: id,
      items: items.map((e) => e.clone()).toList(),
      name: name,
      type: type,
    );
  }

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}
