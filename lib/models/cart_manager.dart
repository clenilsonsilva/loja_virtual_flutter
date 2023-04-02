import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/models/product.dart';

import 'cart_product.dart';
import 'user.dart';
import 'user_manager.dart';

class CartManager {
  List<CartProduct> items = [];

  Userr? user;

  void updateUser(UserManager userManager) {
    user = userManager.usuario;
    items.clear();

    if(user!=null) {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async{
    final QuerySnapshot cartSnap = await user!.cartReference.get();

    items =  cartSnap.docs.map((d) => CartProduct.fromDocument(d)).toList();
  }

  void addToCart(Product product) {
    items.add(CartProduct.fromProduct(product));
  }

}