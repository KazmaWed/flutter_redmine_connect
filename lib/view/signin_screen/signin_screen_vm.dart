import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SigninScreenViewModel {
  final controllers = <String, TextEditingController>{};
  final focuses = <String, FocusNode>{};
  final keys = [
    'email',
    'password',
  ];

  void initialize() {
    for (var key in keys) {
      controllers[key] = TextEditingController();
      focuses[key] = FocusNode();
    }
  }

  Map<String, String> toMap() {
    var output = <String, String>{};
    for (var key in keys) {
      output[key] = controllers[key]!.text;
    }
    return output;
  }

  Future<User?> signin() async {
    User? output;
    final auth = FirebaseAuth.instance;
    await auth
        .signInWithEmailAndPassword(
            email: controllers['email']!.text, password: controllers['password']!.text)
        .then((value) {
      output = value.user;
    });
    return output;
  }
}
