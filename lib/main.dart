import 'package:flutter/material.dart';

import 'screen/base/base_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loja do Clenilson',
      home: BaseScreen()
    );
  }
}
