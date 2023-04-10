import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';
import 'package:loja_virtual/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize(
      {super.key,
      required this.size,
      required this.onRemove,
      required this.onMoveUp,
      required this.onMoveDown});

  final ItemSize size;
  final VoidCallback? onRemove, onMoveUp, onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.name,
            decoration: const InputDecoration(
              labelText: 'Titulo',
              isDense: true,
            ),
            validator: (name) {
              if (name!.isEmpty) {
                return 'Invalido';
              } else {
                return null;
              }
            },
            onChanged: (name) => size.name = name,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: size.stock.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock) {
              if (int.tryParse(stock!) == null) {
                return 'Invalido';
              } else {
                return null;
              }
            },
            onChanged: (stock) => size.stock = int.tryParse(stock)!,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: size.price.toStringAsFixed(2),
            decoration: const InputDecoration(
                labelText: 'Preço', isDense: true, prefixText: 'R\$'),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (price) {
              if (num.tryParse(price!) == null) {
                return 'Invalido';
              } else {
                return null;
              }
            },
            onChanged: (price) => size.price = num.tryParse(price)!,
          ),
        ),
        CustomIconButton(
          iconData: Icons.remove,
          color: Colors.red,
          ontap: onRemove,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          ontap: onMoveUp,
        ),
        CustomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          ontap: onMoveDown,
        ),
      ],
    );
  }
}
