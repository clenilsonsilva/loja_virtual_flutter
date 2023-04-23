import 'package:credit_card_type_detector/credit_card_type_detector.dart';

class CreditCard {
  String? number, holder, expirationDate, securityCode, brand;

  void setHolder(String? name) => holder = name;
  void setExpirationDate(String? date) => expirationDate = date;
  void setCVV(String? cvv) => securityCode = cvv;
  void setNumber(String? number) {
    this.number = number;
    brand = detectCCType(number!)[0].type.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNumber': number?.replaceAll(' ', ''),
      'holder': holder,
      'expirationDate': expirationDate,
      'securityCode': securityCode,
      'brand': brand,
    };
  }

  @override
  String toString() {
    return 'CreditCard{number=$number, holder=$holder, expirationDate=$expirationDate, securityCode=$securityCode, brand=$brand}';
  }
}
