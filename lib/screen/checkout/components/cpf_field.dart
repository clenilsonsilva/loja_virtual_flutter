import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/user_manager.dart';

class CpfField extends StatelessWidget {
  const CpfField({super.key});

  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'CPF',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            TextFormField(
              initialValue: userManager.usuario?.cpf,
              decoration: const InputDecoration(
                hintText: '000.000.000-00',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CpfInputFormatter(),
              ],
              validator: (cpf) {
                if (cpf != null) {
                  if (cpf.isEmpty) {
                    return 'Campo Obrigatorio';
                  } else if (!CPFValidator.isValid(cpf)) {
                    return 'CPF invalido';
                  } else {
                    return null;
                  }
                } else {
                  return 'CPF NULO';
                }
              },
              onSaved: userManager.usuario?.setCpf,
            ),
          ],
        ),
      ),
    );
  }
}
