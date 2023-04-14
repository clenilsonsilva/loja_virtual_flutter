import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/cep_aberto_service.dart';
import 'address.dart';
import 'cart_product.dart';
import 'product.dart';
import 'user.dart';
import 'user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  Userr? user;
  Address? address;

  num productsPrice = 0.0;
  num? deliveryPrice;
  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final firestore = FirebaseFirestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.usuario;
    productsPrice = 0.0;
    items.clear();
    removeAddress();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user!.cartReference.get();

    items = cartSnap.docs
        .map((d) => CartProduct.fromDocument(d)..addListener(_onItemUpdated))
        .toList();
  }

  Future<void> _loadUserAddress() async {
    if (user?.address != null) {
      if (user!.address?.lat != null && user!.address?.long != null) {
        if (await calculateDelivery(
            user!.address!.lat!, user!.address!.long!)) {
          address = user!.address;
          notifyListeners();
        }
      }
    }
  }

  void addToCart(Product product) {
    try {
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      cartProduct.addListener(_onItemUpdated);
      items.add(cartProduct);
      user!.cartReference
          .add(cartProduct.toCardItemMap())
          .then((doc) => cartProduct.id = doc.id);
      _onItemUpdated();
    }
    notifyListeners();
  }

  void _onItemUpdated() {
    productsPrice = 0.0;
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }
      productsPrice += cartProduct.totalPrice;
      _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id.isNotEmpty) {
      user!.cartReference
          .doc(cartProduct.id)
          .update(cartProduct.toCardItemMap());
    }
    notifyListeners();
  }

  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    user!.cartReference.doc(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) {
        return false;
      }
    }
    return true;
  }

  bool get isAdrressValid => address != null && deliveryPrice != null;

  //ADDRESS

  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();
    try {
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      if (cepAbertoAddress != null) {
        address = Address(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade?.nome ?? '',
          state: cepAbertoAddress.estado?.sigla ?? '',
          lat: cepAbertoAddress.latitude,
          long: cepAbertoAddress.longitude,
        );
      }
      loading = false;
    } catch (e) {
      loading = false;
      return Future.error('Cep Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if (await calculateDelivery(address.lat!, address.long!)) {
      user?.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega');
    }
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final doc = await firestore.doc('aux/delivery').get();

    final latStore = doc['latitude'];
    final longStore = doc['longitude'];
    final maxkm = doc['maxkm'];
    final base = doc['base'];
    final km = doc['km'];

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);

    dis /= 1000.0;

    debugPrint('Distance: $dis');

    if (dis > maxkm) {
      return false;
    }

    deliveryPrice = base + dis * km;
    return true;
  }
}
