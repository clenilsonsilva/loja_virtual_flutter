import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/models/credit_card.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'card_text_field.dart';

class CardFront extends StatelessWidget {
  CardFront(
      {super.key,
      required this.numberFocus,
      required this.dateFocus,
      required this.nameFocus,
      required this.finished,
      required this.creditCard});

  final dateFormatter = MaskTextInputFormatter(
    mask: '!#/####',
    filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')},
  );

  final FocusNode numberFocus;
  final FocusNode dateFocus;
  final FocusNode nameFocus;
  final VoidCallback finished;

  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 16,
      child: Container(
        height: 200,
        color: const Color(0xFF1B4B52),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CardTextField(
                    initialValue: creditCard.number,
                    bold: true,
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (numero) {
                      List<CreditCardType> lista = detectCCType(numero);
                      if (numero.length != 19 || lista.isEmpty) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    focusNode: numberFocus,
                    onSubmitted: (_) {
                      dateFocus.requestFocus();
                    },
                    onSaved: creditCard.setNumber,
                  ),
                  CardTextField(
                    initialValue: creditCard.expirationDate,
                    title: 'Validade',
                    hint: '00/0000',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      dateFormatter,
                    ],
                    validator: (validade) {
                      if (validade.length != 7) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    focusNode: dateFocus,
                    onSubmitted: (_) {
                      nameFocus.requestFocus();
                    },
                    onSaved: creditCard.setExpirationDate,
                  ),
                  CardTextField(
                    initialValue: creditCard.holder,
                    bold: true,
                    title: 'Titular',
                    hint: 'Clenilson da Silva',
                    textInputType: TextInputType.text,
                    validator: (name) {
                      if (name.isEmpty) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                    focusNode: nameFocus,
                    onSubmitted: (_) {
                      finished();
                    },
                    onSaved: creditCard.setHolder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
