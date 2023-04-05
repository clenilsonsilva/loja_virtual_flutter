import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';

import 'product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this.product) {
    id = product != null ? product!.id : '';
    productId = product != null ? product!.id : '';
    quantity = 1;
    size = product != null ? product!.selectedSize.name : '';
  }

  final firestore = FirebaseFirestore.instance;

  CartProduct.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    productId = doc['pid'];
    quantity = doc['quantity'];
    size = doc['size'];
    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
        notifyListeners();
      },
    );
  }

  String id = '';
  late String productId;
  late int quantity;
  late String size;

  Product? product;

  ItemSize? get itemSize {
    if (product != null) {
      return product!.findSize(size);
    } else {
      return null;
    }
  }

  num get unitPrice {
    if (product != null) {
      return itemSize!.price;
    } else {
      return 0;
    }
  }

  num get totalPrice => unitPrice * quantity;

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
    if (size == null) {
      return false;
    } else {
      return size.stock >= quantity;
    }
  }
}
