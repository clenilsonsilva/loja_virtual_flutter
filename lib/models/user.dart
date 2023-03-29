import 'package:cloud_firestore/cloud_firestore.dart';

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

  }
  

  late String id;
  late String email;
  late String pass;
  late String name;
  late String confirmPassword;


  DocumentReference get firestorRef => FirebaseFirestore.instance.doc('users/$id');

  Future<void> saveData() async{
    await firestorRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
