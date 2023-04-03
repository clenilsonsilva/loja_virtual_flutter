import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';

import 'product.dart';

class CartProduct extends ChangeNotifier{
  CartProduct.fromProduct(this.product) {
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  final firestore = FirebaseFirestore.instance;

  CartProduct.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    productId = doc['pid'];
    quantity = doc['quantity'];
    size = doc['size'];
    firestore
        .doc('products/$productId')
        .get()
        .then((doc) => product = Product.fromDocument(doc));
  }

  String id = '';
  late String productId;
  late int quantity;
  late String size;

  late Product product;

  ItemSize? get itemSize {
    if(product.id.isEmpty) return null;
    return product.findSize(size);
  }

  num get unitPrice {
    if(product.id.isEmpty) return 0;
    return itemSize?.price ?? 0;
  }

  Map<String, dynamic> toCardItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(Product product) {
    return product.id == productId && product.selectedSize.name == size;
  }

  void increment() {
    quantity++;
    notifyListeners();
  }

  void decrement() {
    quantity--;
    notifyListeners();
  }

  bool get hasStock {
    final size = itemSize;
    if(size==null) {
      return false;
    }
    else {
      return size.stock >= quantity;
    }
  }
}
