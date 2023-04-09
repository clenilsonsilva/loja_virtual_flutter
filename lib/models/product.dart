import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'item_size.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'];
    description = doc['description'];
    images = List.from(doc['images']);
    try {
      sizes = (doc['sizes'] as List<dynamic>)
          .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      sizes =
          ([]).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
    }
  }

  late String id;
  late String name;
  late String description;
  late List<String> images;
  late List<ItemSize> sizes;

  ItemSize _selectedSize =
      ItemSize.fromMap({'name': '', 'price': 0, 'stock': 0});
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize valor) {
    _selectedSize = valor;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } on Exception {
      return null;
    }
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }
}
