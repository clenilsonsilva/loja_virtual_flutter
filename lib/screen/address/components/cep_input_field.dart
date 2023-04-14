import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_iconbutton.dart';
import '../../../models/address.dart';
import '../../../models/cart_manager.dart';

class CepInputField extends StatelessWidget {
  CepInputField({super.key, required this.adress});

  final Address adress;

  final cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    if (adress.zipCode.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Cep',
              hintText: '68.377-065',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            keyboardType: TextInputType.number,
            validator: (cep) {
              if (cep != null) {
                if (cep.isEmpty) {
                  return 'Campo Obrigatório';
                } else if (cep.length != 10) {
                  return 'Cep Inválido';
                } else {
                  return null;
                }
              } else {
                return '';
              }
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (Form.of(context).validate()) {
                context.read<CartManager>().getAddress(cepController.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: primaryColor.withAlpha(100),
            ),
            child: const Text('Buscar Cep'),
          )
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${adress.zipCode}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              iconData: Icons.edit,
              color: primaryColor,
              ontap: () {
                context.read<CartManager>().removeAddress();
              },
              size: 20,
            )
          ],
        ),
      );
    }
  }
}
