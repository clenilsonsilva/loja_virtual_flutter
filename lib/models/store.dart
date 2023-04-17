import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'address.dart';
import '../../../helpers/extensions.dart';

class Store {
  Store.fromDocument(DocumentSnapshot doc) {
    name = doc['name'];
    image = doc['image'];
    phone = doc['phone'];
    address = Address.fromMap(doc['address']);
    opening = (doc['opening'] as Map<String, dynamic>).map((key, value) {
      final timeString = value as String?;
      if (timeString != null && timeString.isNotEmpty) {
        final splitted = timeString.split(RegExp(r"[:-]"));
        return MapEntry(key, {
          'from': TimeOfDay(
              hour: int.parse(splitted[0]), minute: int.parse(splitted[1])),
          'to': TimeOfDay(
              hour: int.parse(splitted[2]), minute: int.parse(splitted[3])),
        });
      } else {
        return MapEntry(key, null);
      }
    });
    print(opening);
  }

  String? name, image, phone;
  Address? address;
  Map<String, Map<String, TimeOfDay>?>? opening;

  String get addressText =>
      '${address?.street}, ${address?.number}${address!.complement.isNotEmpty ? ' - ${address?.complement}' : ''} - '
      '${address?.district}, ${address?.city}/${address?.state}';

  String get oppeningText {
    return 'Seg-Sex: ${formattedPeriod(opening?['monfri'])}\n'
        'Sab: ${formattedPeriod(opening?['saturday'])}\n'
        'Dom: ${formattedPeriod(opening?['sunday'])}';
  }

  String formattedPeriod(Map<String, TimeOfDay>? period) {
    if(period == null) {
      return 'Fechada';
    }
    else {
      return '${period['from']?.formatted()} - ${period['to']?.formatted()}';
    }
  }
}
