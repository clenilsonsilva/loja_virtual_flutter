import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/item_size.dart';

import 'product.dart';

class CartProduct extends ChangeNotifier {
  CartProduct.fromProduct(this._product) {
    productId = product!.id;
    quantity = 1;
    size = product!.selectedSize.name;
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
      },
    );
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    productId = map['pid'];
    quantity = map['quantity'];
    size = map['size'];
    fixedPrice = map['fixedPrice'];
    firestore.doc('products/$productId').get().then(
      (doc) {
        product = Product.fromDocument(doc);
      },
    );
  }

  String? id;
  late String productId;
  late int quantity;
  late String size;
  num? fixedPrice;

  Product? _product;
  Product? get product => _product;
  set product(Product? value) {
    _product = value;
    notifyListeners();
  }

  ItemSize? get itemSize {
    if (product != null) {
      return product?.findSize(size);
    } else {
      return null;
    }
  }

  num get unitPrice {
    if (product != null) {
      return itemSize?.price ?? 0;
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

  Map<String, dynamic> toOrderItemMap() {
    return {
      'pid': productId,
      'quantity': quantity,
      'size': size,
      'fixedPrice': fixedPrice ?? unitPrice,
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
