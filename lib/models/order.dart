import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';
import 'cart_manager.dart';
import 'cart_product.dart';

class Orderr {
  Orderr.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user?.id;
    address = cartManager.address;
  }

  final firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items': items?.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user' : userId,
        'address' : address?.toMap(),

      },
    );
  }

  String? orderId;

  List<CartProduct>? items;
  num? price;

  String? userId;

  Address? address;

  Timestamp? date;
}
