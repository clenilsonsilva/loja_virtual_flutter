class SectionItem {

  SectionItem(this.image, this.product);

  SectionItem.fromMap(Map<String, dynamic> map) {
    image = map['image'];
    product = map['product'];
  }
  
  late String image;
  String? product;

  SectionItem clone() {
    return SectionItem(
      image = image,
      product = product,
    );
  }

  @override
  String toString() {
    return 'Section{image: $image, product: $product}';
  }
}