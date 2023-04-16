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

  Orderr.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'];
    userId = doc['user'];
    address = Address.fromMap(doc['address']);
    // date = doc['date'];
  }

  final firestore = FirebaseFirestore.instance;

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items': items?.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address?.toMap(),
      },
    );
  }

  String? orderId;

  List<CartProduct>? items;
  num? price;

  String? userId;

  Address? address;

  Timestamp? date;

  String get formattedId => '#${orderId?.padLeft(6, '0')}';

  @override
  String toString() {
    return 'Orderr{firestore=$firestore, orderId=$orderId, items=$items, price=$price, userId=$userId, address=$address, date=$date}';
  }
}
