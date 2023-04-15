import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'item_size.dart';

class Product extends ChangeNotifier {
  Product.fromDocument(DocumentSnapshot doc) {
    id = doc.id;
    name = doc['name'];
    description = doc['description'];
    images = List.from(doc['images']);
    try {
      sizes = (doc['sizes'] as List<dynamic>)
          .map((s) => ItemSize.fromMap(s as Map<String, dynamic>))
          .toList();
    } catch (e) {
      sizes =
          ([]).map((s) => ItemSize.fromMap(s as Map<String, dynamic>)).toList();
    }
  }
  Product({
    this.name = '',
    this.id = '',
    this.description = '',
    required this.images,
    required this.sizes,
  });

  final firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$id');
  Reference get storageRef => storage.ref().child('products').child(id);

  late String id;
  late String name;
  late String description;
  late List<String> images;
  late List<ItemSize> sizes;
  late List<dynamic> newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  ItemSize _selectedSize =
      ItemSize.fromMap({'name': '', 'price': 0, 'stock': 0});
  ItemSize get selectedSize => _selectedSize;

  set selectedSize(ItemSize valor) {
    _selectedSize = valor;
    notifyListeners();
  }

  int get totalStock {
    int stock = 0;
    for (final size in sizes) {
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  ItemSize? findSize(String name) {
    try {
      return sizes.firstWhere((s) => s.name == name);
    } catch (e) {
      return null;
    }
  }

  num get basePrice {
    num lowest = double.infinity;
    for (final size in sizes) {
      if (size.price < lowest && size.hasStock) {
        lowest = size.price;
      }
    }
    return lowest;
  }

  List<Map<String, dynamic>> exportSizeList() {
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if (id.isEmpty) {
      final doc = await firestore.collection('products').add(data);
      id = doc.id;
    } else {
      await firestoreRef.update(data);
    }

    final List<String> updateImages = [];
    for (final newImage in newImages) {
      if (images.contains(newImage)) {
        updateImages.add(newImage);
      } else {
        final UploadTask task =
            storageRef.child(const Uuid().v1()).putFile(newImage);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref = storage.refFromURL(image);
          ref.delete();
        } catch (e) {
          debugPrint('Falha ao deletar: $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});

    images = updateImages;

    loading = false;
  }

  Product clone() {
    return Product(
        id: id,
        name: name,
        description: description,
        images: List.from(images),
        sizes: sizes.map((size) => size.clone()).toList());
  }

  @override
  String toString() {
    return 'Product{sizes: $sizes ,id: $id, name: $name, description: $description, images: $images, newImages: $newImages}';
  }
}
