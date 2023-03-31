import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    _loadAllProduct();
  }

  final firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  String _search = ''; 
  String get search => _search;

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];
    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  Future<void> _loadAllProduct() async {
    final snapProducts = await firestore.collection('products').get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
  }
}
