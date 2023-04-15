import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'cart_manager.dart';
import 'product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  final firestore = FirebaseFirestore.instance;

  void updateCart(CartManager value) {
    cartManager = value;
    notifyListeners();
  }

  Future<void> checkout({required Function onStockFail}) async {
    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      debugPrint(e.toString());
    }
    _getOrderId().then((value) => print(value));
  }

  Future<int> _getOrderId() async {
    final ref = firestore.doc('aux/ordercounter');

    try {
      final result = await firestore.runTransaction(
        (tx) async {
          final doc = await tx.get(ref);
          final int orderId = doc['current'];
          tx.update(ref, {'current': orderId + 1});
          return {'orderId': orderId};
        },
      );
      return result['orderId'] as int;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar numero do pedido');
    }
  }

  Future<void> _decrementStock() {
    return firestore.runTransaction(
      (tx) async {
        final List<Product> productsToUpdate = [];
        final List<Product> productWithoutStock = [];

        for (final cartProduct in cartManager!.items) {
          Product product;

          if (productsToUpdate.any((p) => p.id == cartProduct.productId )) {
            product =
                productsToUpdate.firstWhere((p) => p.id == cartProduct.productId);
          } else {
            final doc = await tx
                .get(firestore.doc('products/${cartProduct.productId}'));
            product = Product.fromDocument(doc);
          }

          cartProduct.product = product;

          final size = product.findSize(cartProduct.size);
          if (size!.stock - cartProduct.quantity < 0) {
            productWithoutStock.add(product);
            //TODO
          } else {
            // size.stock -= cartProduct.quantity;
            productsToUpdate.add(product);
          }
        }

        if (productWithoutStock.isNotEmpty) {
          return Future.error(
              '${productWithoutStock.length} produtos sem estoque');
        }

        for (final product in productsToUpdate) {
          for(final cartProduct in cartManager!.items) {
            final size = product.findSize(cartProduct.size);
            size?.stock -= cartProduct.quantity;
          }
          tx.update(
            firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()},
          );
        }
      },
    );
  }
}
