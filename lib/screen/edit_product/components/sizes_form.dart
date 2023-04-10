import 'package:flutter/material.dart';
import 'package:loja_virtual/common/custom_iconbutton.dart';

import '../../../models/item_size.dart';
import '../../../models/product.dart';
import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {
  const SizesForm({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if(sizes!.isEmpty) {
          return 'Insira um tamanho';
        }
        else {
          return null;
        }
      },
      builder: (state) {
        return Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  ontap: () {
                    if (state.value != null) {
                      state.value!.add(ItemSize());
                      state.didChange(state.value);
                    }
                  },
                ),
              ],
            ),
            Column(
              children: state.value!.map<Widget>((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value!.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value?.first
                      ? () {
                          final index = state.value?.indexOf(size);
                          state.value?.remove(size);
                          state.value?.insert(index! - 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveDown: size != state.value?.last
                      ? () {
                          final index = state.value?.indexOf(size);
                          state.value?.remove(size);
                          state.value?.insert(index! + 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                );
              }).toList(),
            ),
            if(state.hasError) 
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                state.errorText ?? '',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),

              ),
            )
          ],
        );
      },
    );
  }
}
