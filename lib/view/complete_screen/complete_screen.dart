import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompleteScreen extends StatefulWidget {
  const CompleteScreen({Key? key}) : super(key: key);

  @override
  State<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<CompleteScreen> {
  // final redmineUrl = 'https://pm.tongullman.com/projects/testtest/issues';
  final redmineUrl = 'https://pm.tongullman.com/projects/kiitone_test/issues';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('送信完了'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              const SizedBox(height: 48),
              vaultonIcon(),
              const SizedBox(height: 28),
              // Row(children: [
              //   const Spacer(),
              TextButton(
                child: const Padding(padding: EdgeInsets.all(8), child: Text('Redmineチケットを確認')),
                onPressed: () => launchUrl(Uri.parse(redmineUrl)),
              ),
              // ]),
              // Row(children: [
              //   const Spacer(),
              TextButton(
                child: const Padding(padding: EdgeInsets.all(8), child: Text('トップに戻る')),
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              // ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget vaultonIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.audiotrack_rounded,
          size: 212,
          color: Theme.of(context).primaryColor.withAlpha(128),
        ),
      ],
    );
  }
}
