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
      filteredProducts.addAll(allProducts
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  Future<void> _loadAllProduct() async {
    final snapProducts = await firestore
        .collection('products')
        .where('deleted', isEqualTo: false)
        .get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
  }

  Product? findProductByID(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } on Exception {
      return null;
    }
  }

  void update(Product product) {
    allProducts.removeWhere((p) => p.id == product.id);
    allProducts.add(product);
    notifyListeners();
  }

  void delete(Product product) {
    product.delete();
    allProducts.removeWhere((p) => p.id == product.id);
    notifyListeners();
  }
}
