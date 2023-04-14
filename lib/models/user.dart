import 'package:cloud_firestore/cloud_firestore.dart';

import 'address.dart';

class Userr {
  Userr(
      {this.email = '',
      this.pass = '',
      this.confirmPassword = '',
      this.name = '',
      this.id = ''});

  Userr.fromDocument(DocumentSnapshot doc) {
    email = doc['email'];
    name = doc['name'];
    id = doc.id;
    Map<String, dynamic> dataMap = doc.data() as Map<String, dynamic>;
    print(dataMap);
    if(dataMap.containsKey('address')){
      address = Address.fromMap(doc['address']);
    }
  }

  late String id;
  late String email;
  late String pass;
  late String name;
  late String confirmPassword;
  bool admin = false;

  Address? address;

  DocumentReference get firestorRef =>
      FirebaseFirestore.instance.doc('users/$id');

  CollectionReference get cartReference => firestorRef.collection('cart');

  Future<void> saveData() async {
    await firestorRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (address?.toMap() != null) 'address': address!.toMap(),
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }
}
