class ItemSize {

  ItemSize.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    price = map['price'];
    stock = map['stock'];
  }

  late String name;
  late num price;
  late int stock;

  bool get hasStock => stock > 0;

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}