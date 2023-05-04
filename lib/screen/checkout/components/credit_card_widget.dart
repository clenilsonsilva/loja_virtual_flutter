import 'package:cloud_functions/cloud_functions.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:loja_virtual/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'card_back.dart';
import 'card_front.dart';

class CreditCardWidget extends StatefulWidget {
  CreditCardWidget({super.key, required this.creditCard});

  final CreditCard creditCard;

  @override
  State<CreditCardWidget> createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  bool valor = false;
  final cardKey = GlobalKey<FlipCardState>();

  final numberFocus = FocusNode();

  final dateFocus = FocusNode();

  final nameFocus = FocusNode();

  final cvvFocus = FocusNode();

  showNotification() {
    setState(() {
      print('oie');
      valor = !valor;
      print(valor);
      if (valor) {
        Provider.of<NotificationService>(context, listen: false)
            .showNotification(
          CustomNotification(
            id: 1,
            title: 'Teste',
            body: 'Acesse o app!',
            payload: '/notification',
          ),
        );
      }
    });
  }

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
              creditCard: widget.creditCard,
              nameFocus: nameFocus,
              dateFocus: dateFocus,
              numberFocus: numberFocus,
              finished: () {
                cardKey.currentState?.toggleCard();
                cvvFocus.requestFocus();
              },
            ),
            back: CardBack(
              creditCard: widget.creditCard,
              cvvFocus: cvvFocus,
            ),
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     cardKey.currentState?.toggleCard();
          //     final response = await FirebaseFunctions.instance
          //         .httpsCallable('addMessage')
          //         .call({"teste": "Clenilson"});
          //     showNotification;
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.transparent,
          //     elevation: 0,
          //   ),
          //   child: const Text('Virar Cartão'),
          // )
          GestureDetector(
            child: const Text('Virar Cartão'),
            onTap: showNotification,
          ),
        ],
      ),
    );
  }
}
