import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'products.dart';

class ProductManager extends ChangeNotifier{
  ProductManager() {
    _loadAllProduct();
  }

  final firestore = FirebaseFirestore.instance;

  List<Product> allProducts = [];

  Future<void> _loadAllProduct() async {
    final snapProducts = await firestore.collection('products').get();

    allProducts =
        snapProducts.docs.map((d) => Product.fromDocument(d)).toList();
    notifyListeners();
  }
}
