import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

import 'card_back.dart';
import 'card_front.dart';

class CreditCardWidget extends StatelessWidget {
  CreditCardWidget({super.key});

  final cardKey = GlobalKey<FlipCardState>();
  final numberFocus = FocusNode();
  final dateFocus = FocusNode();
  final nameFocus = FocusNode();
  final cvvFocus = FocusNode();

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
            front: CardFront(
              nameFocus: nameFocus,
              dateFocus: dateFocus,
              numberFocus: numberFocus,
              finished: () {
                cardKey.currentState?.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              cvvFocus: cvvFocus,
            ),
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
