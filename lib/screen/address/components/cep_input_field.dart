import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../common/custom_iconbutton.dart';
import '../../../models/address.dart';
import '../../../models/cart_manager.dart';

class CepInputField extends StatefulWidget {
  const CepInputField({super.key, required this.adress});

  final Address adress;

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final cepController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    if (widget.adress.zipCode!.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            enabled: !cartManager.loading,
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
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),
          ElevatedButton(
            onPressed: !cartManager.loading
                ? () async {
                    if (Form.of(context).validate()) {
                      try {
                        await context
                            .read<CartManager>()
                            .getAddress(cepController.text);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.toString(),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                : null,
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
                'CEP: ${widget.adress.zipCode}',
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
