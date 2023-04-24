import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'address.dart';

class Userr {
  Userr({
    this.email = '',
    this.pass = '',
    this.confirmPassword = '',
    this.name = '',
    this.id = '',
    this.cpf = '',
  });

  Userr.fromDocument(DocumentSnapshot doc) {
    email = doc['email'];
    name = doc['name'];
    id = doc.id;
    cpf = doc['cpf'];
    Map<String, dynamic> dataMap = doc.data() as Map<String, dynamic>;
    if (dataMap.containsKey('address')) {
      address = Address.fromMap(doc['address']);
    }
  }

  late String id;
  late String email;
  late String pass;
  late String name;
  late String? cpf;
  late String confirmPassword;
  bool admin = false;

  Address? address;

  DocumentReference get firestorRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestorRef.collection('cart');

  CollectionReference get tokensReference => firestorRef.collection('tokens');

  Future<void> saveData() async {
    await firestorRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address?.toMap() != null) 'address': address!.toMap(),
      if (cpf != null) 'cpf': cpf,
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }

  void setCpf(String? cpf) {
    this.cpf = cpf ?? '';
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    await tokensReference.doc(token).set({
      'token': token,
      'updatedAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem,
    });
  }
}
