import 'package:cloud_firestore/cloud_firestore.dart';

import 'section_item.dart';


class Section {
  Section.fromDocument(DocumentSnapshot doc) {
    name = doc['name'];
    type = doc['type'];
    items = (doc['items'] as List).map((i) => SectionItem.fromMap(i)).toList();
  }

  late String name;
  late String type;
  late List<SectionItem> items;

  @override
  String toString() {
    return 'Section{name: $name, type: $type, items: $items}';
  }
}