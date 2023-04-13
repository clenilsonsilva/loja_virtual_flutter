import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/services/cep_aberto_service.dart';
import 'myapp.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  CepAbertoService()
      .getAddressFromCep('68377065')
      .then((address) => print(address));
  runApp(const MyApp());
}
