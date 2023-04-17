import 'package:flutter/material.dart';
import 'package:loja_virtual/models/product_manager.dart';
import 'package:loja_virtual/screen/edit_product/components/delete_order_dialog.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import 'components/images_form.dart';
import 'components/sizes_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product? p, {super.key})
      : editing = p != null,
        product = p?.clone() ?? Product(images: [], sizes: []);

  final Product product;
  final formKey = GlobalKey<FormState>();
  final bool editing;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Anúncio' : 'Criar Anúncio'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            if (editing)
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => DeleteOrderDialgog(product: product));
                },
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(product: product),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: product.name,
                      decoration: const InputDecoration(
                        hintText: 'Titulo',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      validator: (name) {
                        if (name != null) {
                          if (name.length < 6) {
                            return 'Titulo muito curto';
                          } else {
                            return null;
                          }
                        } else {
                          return 'ERRO';
                        }
                      },
                      onSaved: (name) => product.name = name!,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextFormField(
                      initialValue: product.description,
                      style: const TextStyle(fontSize: 16),
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      validator: (desc) {
                        if (desc != null) {
                          if (desc.length < 10) {
                            return 'Descrição muito curta';
                          } else {
                            return null;
                          }
                        } else {
                          return 'ERRO';
                        }
                      },
                      onSaved: (desc) => product.description = desc!,
                    ),
                    SizesForm(
                      product: product,
                    ),
                    const SizedBox(height: 20),
                    Consumer<Product>(
                      builder: (context, product, child) {
                        return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: !product.loading
                                ? () async {
                                    if (formKey.currentState?.validate() !=
                                        null) {
                                      if (formKey.currentState!.validate()) {
                                        formKey.currentState!.save();
                                        await product.save();
                                        context
                                            .read<ProductManager>()
                                            .update(product);
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  }
                                : null,
                            child: product.loading
                                ? const CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                                : const Text(
                                    'Salvar',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
