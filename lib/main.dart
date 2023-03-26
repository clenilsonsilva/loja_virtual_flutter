import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  runApp(const MainApp());
  await Firebase.initializeApp();
  var document = await FirebaseFirestore.instance.doc('pedidos/00001').get();
  print(document.data()!['usuario']);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp (
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
