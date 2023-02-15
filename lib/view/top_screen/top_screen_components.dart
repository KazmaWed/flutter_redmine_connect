import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class VaultonMarkdown extends MarkdownStyleSheet {
  static MarkdownStyleSheet styleSheet(context) {
    return MarkdownStyleSheet(
      h1: Theme.of(context).textTheme.titleLarge!.copyWith(
            // color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
      h2: Theme.of(context).textTheme.titleMedium!.copyWith(
            // color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
      h3: Theme.of(context).textTheme.bodyMedium!.copyWith(
            // fontWeight: FontWeight.bold,
            // color: Colors.black54,
            color: Theme.of(context).primaryColor,
          ),
    );
  }
}

class ConfidentialInfoDescription extends StatelessWidget {
  const ConfidentialInfoDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final futureMarkdownBody = rootBundle.loadString('assets/description_secret.md');
//     final futureMarkdownBody = Future<String>.value('''
// ## 機密情報について
// ### 機密情報にあたるもの
// - 不正利用をされないよう共有範囲を制限する必要のある全ての情報とファイル
// - Webサービスへのログイン情報 (メールアドレス, ID, パスワードなど)
// - 鍵ファイル (pem, p12など)
// - EC2などのサーバー情報やWordPress管理画面へのログイン情報、SNSなどのアカウント情報も含まれます

// ### 機密情報の扱いについて
// - 新規で作成、取得した情報はこちらのフォームより情報保存依頼を行ってください
// - 必要であれば利用中の社用PCのIDManagerまたはKeePassXCに情報を保存してください
// - メモ帳やtxtファイル、Wikiなど、規定の方法以外で保存や管理をしないでください
// ''');
    return Row(children: [
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: FutureBuilder(
              future: futureMarkdownBody,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Text('処理中');
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData) {
                  return const Text('データなし');
                } else {
                  final markdownBody = snapshot.data!;
                  return MarkdownBody(
                    selectable: true,
                    styleSheet: VaultonMarkdown.styleSheet(context),
                    data: markdownBody,
                  );
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

class OtherDescription extends StatelessWidget {
  const OtherDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final futureMarkdownBody = rootBundle.loadString('assets/description_non_secret.md');
//     final futureMarkdownBody = Future<String>.value('''
// ## 登録が不要なもの
// ### テスト用アカウント
// - テスト用サイトで検証のために作成したアカウントの情報
// - 検証機で利用するアカウント
// - テストサイトのサーバー情報やBasic認証情報などは機密情報として取り扱ってください

// ### 社内管理ツール類のアカウント\n
// - Slack, Notion, Office, TeamViewer

// ### 企業として契約しているもの\n
// - Adobe, Office, フォント

// ### プロジェクト管理ツールの個人アカウント\n
// - Teams, Bit Bucket, Git Bucketなど
// ''');
    return Row(children: [
      Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: FutureBuilder(
              future: futureMarkdownBody,
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Text('処理中');
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (!snapshot.hasData) {
                  return const Text('データなし');
                } else {
                  final markdownBody = snapshot.data!;
                  return MarkdownBody(
                    selectable: true,
                    styleSheet: VaultonMarkdown.styleSheet(context),
                    data: markdownBody,
                  );
                }
              },
            ),
          ),
        ),
      ),
    ]);
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        child: const Padding(padding: EdgeInsets.all(12), child: Text('登録依頼フォームに進む')),
      ),
    );
  }
}
