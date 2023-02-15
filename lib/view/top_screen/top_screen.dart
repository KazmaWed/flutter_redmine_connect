import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/view/info_list_screen/info_list_screen.dart';
import 'package:vaulton/view/info_list_screen/info_list_screen_vm.dart';
import 'package:vaulton/view/signin_screen/signin_screen.dart';
import 'package:vaulton/view/top_screen/top_screen_components.dart';

class TopScreen extends ConsumerWidget {
  const TopScreen({Key? key}) : super(key: key);

  @override
  Widget build(context, ref) {
    void onTap() {
      final viewModel = ref.watch(infoListScreenViewModelProvider);
      viewModel.init();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return const InfoListScreen();
      }));
    }

    Widget logoutButton() {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                return const SigninScreen();
              }));
            });
          },
          child: const Text(
            'サインアウト',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('vaulton'),
        automaticallyImplyLeading: false,
        actions: [logoutButton()],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                const ConfidentialInfoDescription(),
                const OtherDescription(),
                const SizedBox(height: 8),
                RegisterButton(onTap: () => onTap()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
