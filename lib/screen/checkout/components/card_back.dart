import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/screen/checkout/components/card_text_field.dart';

import '../../../models/credit_card.dart';

class CardBack extends StatelessWidget {
  const CardBack({super.key, required this.cvvFocus, required this.creditCard});

  final FocusNode cvvFocus;

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
        child: Column(
          children: [
            Container(
              color: Colors.black,
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 16),
            ),
            Row(
              children: [
                Expanded(
                    flex: 70,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      color: Colors.grey,
                      child: CardTextField(
                        initialValue: creditCard.securityCode,
                        textAlign: TextAlign.end,
                        hint: '123',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        maxLength: 3,
                        textInputType: TextInputType.number,
                        validator: (cvv) {
                          if (cvv.length != 3) {
                            return 'Inválido';
                          } else {
                            return null;
                          }
                        },
                        focusNode: cvvFocus,
                        onSubmitted: null,
                        onSaved: creditCard.setCVV,
                      ),
                    )),
                const Expanded(
                  flex: 30,
                  child: SizedBox(),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
