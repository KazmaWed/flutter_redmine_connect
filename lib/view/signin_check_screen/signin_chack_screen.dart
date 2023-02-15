import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vaulton/view/signin_screen/signin_screen.dart';
import 'package:vaulton/view/top_screen/top_screen.dart';

class SigninCheckScreen extends StatefulWidget {
  const SigninCheckScreen({Key? key}) : super(key: key);

  @override
  State<SigninCheckScreen> createState() => _SigninCheckScreenState();
}

class _SigninCheckScreenState extends State<SigninCheckScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          // return const ConditionScreen();
          return const TopScreen();
        } else {
          return const SigninScreen();
        }
      },
    );
  }
}
