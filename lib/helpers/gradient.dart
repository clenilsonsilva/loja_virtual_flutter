import 'package:flutter/material.dart';

class Gradientt extends StatelessWidget {
  const Gradientt({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: SweepGradient(
          colors: [
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.red,
            Colors.blue
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1],
        ),
      ),
    );
  }
}
