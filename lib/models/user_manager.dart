import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';

import 'user.dart';

class UserManager extends ChangeNotifier{
  UserManager() {
    _loadCurrentUser();
  }

  late User usuario;

  final auth = FirebaseAuth.instance;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn(
      {required Userr user,
      required Function onFail,
      required Function onSucess}) async {
        loading = true;
    try {
      final authResult = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.pass);
          usuario = authResult.user!;
      onSucess();
    } on FirebaseAuthException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    User? currentUser =  await auth.currentUser;
    if(currentUser!=null) {
      usuario = currentUser;
      debugPrint(usuario.uid);
    }
    notifyListeners();
  }

}
