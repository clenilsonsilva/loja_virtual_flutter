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
  String street, number, complement, district, zipCode, city, state;
  double lat, long;
}
