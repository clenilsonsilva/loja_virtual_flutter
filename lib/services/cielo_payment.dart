import 'package:cloud_functions/cloud_functions.dart';

import '../models/credit_card.dart';
import '../models/user.dart';

class CieloPayment {
  final functions = FirebaseFunctions.instance;
  Future<void> authorize(
      {required CreditCard creditCard,
      required num price,
      required String orderId,
      required Userr user}) async {
    final Map<String, dynamic> dataSale = {
      'merchantOrderId': orderId,
      'amount': (price * 100).toInt(),
      'softDescriptor': "Silva's Store",
      'installments': 1,
      'creditCard': creditCard.toJson(),
      'cpf': user.cpf,
      'paymentType': 'CreditCard',
    };
    final callable = functions.httpsCallable('authorizeCreditCard');
    final response = await callable.call(dataSale);
    print(response.data);
  }
}
