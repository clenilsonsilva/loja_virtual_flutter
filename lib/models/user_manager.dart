import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loja_virtual/helpers/firebase_errors.dart';

import 'user.dart';


class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  late Userr usuario;

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
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
      await _loadCurrentUser(user: authResult.user);
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

  Future<void> _loadCurrentUser({User? user}) async {
    final currentUser = user ?? auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot docUser = await firestore.collection('users').doc(currentUser.uid).get();
      usuario = Userr.fromDocument(docUser);
      notifyListeners();
    }
  }

  Future<void> singUp(Userr user, Function onFail, Function onSucess) async {
    _loading = true;
    try {
      final result = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.pass);

      user.id = result.user!.uid;

      usuario = user;

      await user.saveData();

      onSucess();

    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    _loading = false;
  }
}
