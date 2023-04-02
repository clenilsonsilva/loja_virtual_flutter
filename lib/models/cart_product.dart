import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/item_size.dart';

import 'product.dart';

class CartProduct {
  CartProduct.fromProduct(this.product){
    productId = product.id;
    quantity = 1;
    size = product.selectedSize.name;
  }

  final firestore = FirebaseFirestore.instance;

  CartProduct.fromDocument(DocumentSnapshot doc) {
    productId = doc['pid'];
    quantity = doc['quantity'];
    size = doc['size'];
    firestore.doc('products/$productId').get().then(
      (doc) => product = Product.fromDocument(doc));
  }



  late String productId;
  late int quantity;
  late String size;

  late Product product;

  ItemSize? get itemSize {
    return product.findSize(size);
  }

  num get unitPrice {
    return itemSize?.price ?? 0;
  }
}