import 'package:flutter/material.dart';
import 'package:vaulton/model/kii_tone_model.dart';
import 'package:vaulton/view/signin_screen/signin_screen_vm.dart';
import 'package:vaulton/view/top_screen/top_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final viewModel = SigninScreenViewModel();
  var responceStr = '';

  @override
  Widget build(BuildContext context) {
    viewModel.initialize();

    Future<void> onSignin() async {
      showNetworkingCircular(context);

      await viewModel.signin().then((value) async {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          // return const ConditionScreen();
          return const TopScreen();
        }));
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        setState(() {
          responceStr = error.toString();
        });
      });
    }

    Widget signinForm() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Form(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  controller: viewModel.controllers['email'],
                  focusNode: viewModel.focuses['email'],
                  decoration: const InputDecoration(labelText: 'Email'),
                  onEditingComplete: () => viewModel.focuses['password']!.requestFocus(),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: viewModel.controllers['password'],
                  focusNode: viewModel.focuses['password'],
                  decoration: const InputDecoration(labelText: 'Password'),
                  onEditingComplete: () => onSignin(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => onSignin(),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('サインイン'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(responceStr)],
                ),
              ]),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('サインイン'),
      ),
      body: signinForm(),
    );
  }
}
