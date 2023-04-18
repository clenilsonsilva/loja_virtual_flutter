import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'card_back.dart';
import 'card_front.dart';

class CreditCardWidget extends StatelessWidget {
  CreditCardWidget({super.key});

  final cardKey = GlobalKey<FlipCardState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FlipCard(
            key: cardKey,
            flipOnTouch: false,
            direction: FlipDirection.HORIZONTAL,
            speed: 700,
            front: CardFront(),
            back: CardBack(),
          ),
          ElevatedButton(
            onPressed: () {
              cardKey.currentState?.toggleCard();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            child: const Text('Virar Cartão'),
          )
        ],
      ),
    );
  }
}
