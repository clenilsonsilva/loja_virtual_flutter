import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:credit_card_type_detector/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'card_text_field.dart';

class CardFront extends StatelessWidget {
  CardFront({super.key});

  final dateFormatter = MaskTextInputFormatter(
    mask: '!#/####',
    filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')},
  );

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
                    bold: true,
                    title: 'Número',
                    hint: '0000 0000 0000 0000',
                    textInputType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CartaoBancarioInputFormatter(),
                    ],
                    validator: (numero) {
                      if (numero.length != 19) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    },
                  ),
                  CardTextField(
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
                  ),
                  CardTextField(
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
