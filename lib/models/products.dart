

import 'package:cloud_firestore/cloud_firestore.dart';

class Product{

  Product.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'];
    description = doc['description'];
    images = List.from(doc['images']);
  }
  late String id;
  late String name;
  late String description;
  late List<String> images;
}