class Address {
  Address({
    this.street = '',
    this.number = '',
    this.complement = '',
    this.district = '',
    this.zipCode = '',
    this.city = '',
    this.state = '',
    this.lat = 0,
    this.long = 0,
  });
  String? street, number, complement, district, zipCode, city, state;
  double? lat, long;

  Address.fromMap(Map<String, dynamic> map) {
    street = map['street'];
    number = map['number'];
    complement = map['complement'];
    district = map['district'];
    zipCode = map['zipCode'];
    city = map['city'];
    state = map['state'];
    lat = map['lat'];
    long = map['long'];
  }

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'number': number,
      'complement': complement,
      'district': district,
      'zipCode': zipCode,
      'city': city,
      'state': state,
      'lat': lat,
      'long': long,
    };
  }
}
