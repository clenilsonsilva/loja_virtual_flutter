import 'package:loja_virtual/models/product.dart';

import 'cart_product.dart';

class CartManage {
  List<CartProduct> items = [];

  void addToCart(Product product) {
    items.add(CartProduct.fromProduct(product));
  }

}