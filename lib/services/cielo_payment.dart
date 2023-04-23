import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../models/credit_card.dart';
import '../models/user.dart';

class CieloPayment {
  final functions = FirebaseFunctions.instance;
  Future<String> authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required Userr user}) async {
    try {
      final Map<String, dynamic> dataSale = {
        'merchantOrderId': orderId,
        'amount': (price * 100).toInt(),
        'softDescriptor': "Silv' sStore",
        'installments': 1,
        'creditCard': creditCard.toJson(),
        'cpf': user.cpf,
        'paymentType': 'CreditCard',
      };
      final callable = functions.httpsCallable('authorizeCreditCard');
      final response = await callable.call(dataSale);
      final data = Map<String, dynamic>.from(response.data);
      if (data['success']) {
        return data['paymentId'];
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message']);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  Future<void> capture(String payId) async {
    final Map<String, dynamic> captureData = {
      'payId': payId,
    };
    final callable = functions.httpsCallable('captureCreditCard');
    final response = await callable.call(captureData);
    final data = Map<String, dynamic>.from(response.data);
    if (data['success']) {
      debugPrint('Captura realizada com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }

  Future<void> cancel(String? payId) async {
    final Map<String, dynamic> cancelData = {
      'payId': payId,
    };
    final callable = functions.httpsCallable('cancelCreditCard');
    final response = await callable.call(cancelData);
    final data = Map<String, dynamic>.from(response.data);
    if (data['success']) {
      debugPrint('Cancelamento realizado com sucesso');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message']);
    }
  }
}
