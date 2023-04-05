class SectionItem {

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'];
    product = map['product'];
  }
  
  late String image;
  String? product;

  @override
  String toString() {
    return 'Section{image: $image, product: $product}';
  }
}