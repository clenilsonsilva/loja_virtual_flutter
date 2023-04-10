class ItemSize {
  ItemSize.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    price = map['price'];
    stock = map['stock'];
  }

  ItemSize({
    this.name = '',
    this.price = 0,
    this.stock = 0,
  });

  late String name;
  late num price;
  late int stock;


  bool get hasStock => stock > 0;

  ItemSize clone() {
    return ItemSize(
      name: name,
      price: price,
      stock: stock,
    );
  }

  @override
  String toString() {
    return 'ItemSize{name: $name, price: $price, stock: $stock}';
  }
}
