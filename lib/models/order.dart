import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/services/cielo_payment.dart';

import 'address.dart';
import 'cart_manager.dart';
import 'cart_product.dart';

enum Status { canceled, preparing, transporting, delivered }

class Orderr {
  Orderr.fromCartManager(CartManager cartManager) {
    items = List.from(cartManager.items);
    price = cartManager.totalPrice;
    userId = cartManager.user?.id;
    address = cartManager.address;
    status = Status.preparing;
  }

  Orderr.fromDocument(DocumentSnapshot doc) {
    orderId = doc.id;

    items = (doc['items'] as List<dynamic>).map((e) {
      return CartProduct.fromMap(e as Map<String, dynamic>);
    }).toList();

    price = doc['price'];
    userId = doc['user'];
    address = Address.fromMap(doc['address']);
    date = doc['date'];
    status = Status.values[doc['status']];
    payId = doc['payId'];
  }

  final firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef =>
      firestore.collection('orders').doc(orderId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc['status']];
  }

  Future<void> save() async {
    firestore.collection('orders').doc(orderId).set(
      {
        'items': items?.map((e) => e.toOrderItemMap()).toList(),
        'price': price,
        'user': userId,
        'address': address?.toMap(),
        'status': status?.index,
        'date': Timestamp.now(),
        'payId': payId,
      },
    );
  }

  String? orderId;

  String? payId;

  List<CartProduct>? items;
  num? price;

  String? userId;

  Address? address;

  Status? status;

  Timestamp? date;

  String get formattedId => '#${orderId?.padLeft(6, '0')}';

  String? get statusText => getStatusText(status);

  Function()? get back {
    if (status?.index != null) {
      return status!.index >= Status.transporting.index
          ? () {
              status = Status.values[status!.index - 1];
              firestoreRef.update({'status': status?.index ?? 1});
            }
          : null;
    } else {
      return null;
    }
  }

  Function()? get advance {
    if (status?.index != null) {
      return status!.index <= Status.transporting.index
          ? () {
              status = Status.values[status!.index + 1];
              firestoreRef.update({'status': status?.index ?? 1});
            }
          : null;
    } else {
      return null;
    }
  }

  Future<void> cancel() async {
    try {
      await CieloPayment().cancel(payId);
      status = Status.canceled;
      firestoreRef.update({'status': status?.index ?? 1});
    } catch (e) {
      debugPrint('Erro ao Cancelar');
      return Future.error('Falha ao cancelar');
    }
  }

  static String? getStatusText(Status? status) {
    switch (status) {
      case Status.canceled:
        return 'Cancelado';
      case Status.preparing:
        return 'Em Preparação';
      case Status.transporting:
        return 'Em Transporte';
      case Status.delivered:
        return 'Entregue';
      default:
        return '';
    }
  }

  @override
  String toString() {
    return 'Orderr{firestore=$firestore, orderId=$orderId, items=$items, price=$price, userId=$userId, address=$address, date=$date}';
  }
}
