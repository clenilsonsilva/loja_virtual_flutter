import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/cielo_payment.dart';
import 'cart_manager.dart';
import 'credit_card.dart';
import 'order.dart';
import 'product.dart';

class CheckoutManager extends ChangeNotifier {
  CartManager? cartManager;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final firestore = FirebaseFirestore.instance;
  final cieloPayment = CieloPayment();

  void updateCart(CartManager value) {
    cartManager = value;
    notifyListeners();
  }

  Future<void> checkout({
    required CreditCard creditCard,
    required Function onStockFail,
    required Function onSucess,
    required Function onPayFail,
  }) async {
    loading = true;

    final orderId = await _getOrderId();
    String payId = '';

    try {
      payId = await cieloPayment.authorize(
          creditCard: creditCard,
          price: cartManager!.totalPrice,
          orderId: orderId.toString(),
          user: cartManager!.user!);
      debugPrint('success: $payId');
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    try {
      await _decrementStock();
    } catch (e) {
      onStockFail(e);
      loading = false;
      return;
    }

    try {
      await cieloPayment.capture(payId);
    } catch (e) {
      onPayFail(e);
      loading = false;
      return;
    }

    final order = Orderr.fromCartManager(cartManager!);
    order.orderId = orderId.toString();
    order.payId = payId;

    await order.save();

    cartManager?.clear();

    onSucess(order);

    loading = false;
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

          if (productsToUpdate.any((p) => p.id == cartProduct.productId)) {
            product = productsToUpdate
                .firstWhere((p) => p.id == cartProduct.productId);
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
            size.stock -= cartProduct.quantity;
            productsToUpdate.add(product);
          }
        }

        if (productWithoutStock.isNotEmpty) {
          return Future.error(
              '${productWithoutStock.length} produtos sem estoque');
        }

        for (final product in productsToUpdate) {
          tx.update(
            firestore.doc('products/${product.id}'),
            {'sizes': product.exportSizeList()},
          );
        }
      },
    );
  }
}
