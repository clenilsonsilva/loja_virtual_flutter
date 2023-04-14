import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/address.dart';
import '../../../models/cart_manager.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField({super.key, required this.address});

  final Address address;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    String? emptyValidator(String? text) {
      if (text != null) {
        if (text.isEmpty) {
          return 'Campo obrigatório';
        } else {
          return null;
        }
      } else {
        return '';
      }
    }

    if (address.zipCode.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t ?? '',
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: address.number,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Número',
                    hintText: '123',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t ?? '',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => address.complement = t ?? '',
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Brasilia',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.district = t ?? '',
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Cidade',
                    hintText: 'Altamira',
                  ),
                  validator: emptyValidator,
                  onSaved: (t) => address.city = t ?? '',
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'PA',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (e) {
                    if (e != null) {
                      if (e.isEmpty) {
                        return 'Campo obrigatório';
                      } else if (e.length != 2) {
                        return 'Inválido';
                      } else {
                        return null;
                      }
                    } else {
                      return '';
                    }
                  },
                  onSaved: (t) => address.state = t ?? '',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              disabledBackgroundColor: primaryColor.withAlpha(100),
            ),
            onPressed: () async {
              if (Form.of(context).validate()) {
                Form.of(context).save();
                try {
                  await context.read<CartManager>().setAddress(address);
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
            },
            child: const Text('Calcular Frete'),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
