import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/model/confidential_info_model.dart';
import 'package:vaulton/model/kii_tone_model.dart';
import 'package:vaulton/view/complete_screen/complete_screen.dart';
import 'package:vaulton/view/condition_screen/condition_screen.dart';
import 'package:vaulton/view/info_list_screen/info_list_screen_vm.dart';

class InfoListScreen extends StatefulWidget {
  const InfoListScreen({Key? key}) : super(key: key);

  @override
  State<InfoListScreen> createState() => _InfoListScreenState();
}

class _InfoListScreenState extends State<InfoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final viewModel = ref.read(infoListScreenViewModelProvider);
      const title = '新規登録';
      final style = TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
      );

      Future<void> onAdd() async {
        await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) {
            return const ConditionScreen();
          }),
        );
        setState(() {});
      }

      Future<void> onSend() async {
        if (viewModel.info.body.isEmpty) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                title: const Text("情報未登録"),
                content: const Text("保存依頼をする機密情報を1件以上登録してください"),
                actions: [
                  TextButton(
                    child: const Text("閉じる"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              );
            },
          );
        } else {
          showNetworkingCircular(context);
          await viewModel.gasPost().then((succeed) {
            if (succeed) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (cotext) {
                return const CompleteScreen();
              }));
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const Scaffold(body: Text('送信失敗'));
              }));
            }
          });
        }
      }

      Widget basicInfoCard() {
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText('基本情報', style: style),
                TextFormField(
                  controller: viewModel.cliantController,
                  onChanged: (value) => {viewModel.info.project = value},
                  decoration: const InputDecoration(labelText: 'クライアント'),
                ),
                TextFormField(
                  controller: viewModel.projectController,
                  onChanged: (value) => {viewModel.info.cliant = value},
                  decoration: const InputDecoration(labelText: 'プロジェクト'),
                ),
              ],
            ),
          ),
        );
      }

      Widget addButton() {
        final style = Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).primaryColor,
            );
        return TextButton(
          onPressed: () async => onAdd(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Text('追加する', style: style),
          ),
        );
      }

      Widget sendbutton() {
        return Container(
          height: 96,
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async => onSend(),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text('登録依頼を送信する'),
            ),
          ),
        );
      }

      Widget infoTile(InfoElement element) {
        final key = element.key;
        final value = element.value == '' ? '未入力' : element.value;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(key),
            const SizedBox(width: 8),
            Flexible(child: Container(height: 1, color: Colors.black12)),
            const SizedBox(width: 8),
            Text(value, maxLines: null),
          ],
        );
      }

      Widget infoListItem(int index) {
        final style = Theme.of(context).textTheme.titleMedium!;
        final removeStyle = Theme.of(context).textTheme.bodySmall!;

        final item = viewModel.info.body[index];
        var text = '';
        for (var element in item.elementList) {
          text += '${element.key}: ${element.value}\n';
        }

        void onRemove() {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                title: const Text("登録を取り消す"),
                content: Text(text),
                actions: [
                  TextButton(
                    child: const Text("キャンセル"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("確定"),
                    onPressed: () => setState(() {
                      Navigator.pop(context);
                      viewModel.removeInfoItem(ref, index);
                    }),
                  ),
                ],
              );
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  children: [
                    Text(item.serviceTitle, style: style),
                    const Spacer(),
                    InkWell(
                      onTap: () => onRemove(),
                      child: Text('取消', style: removeStyle),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                for (var element in item.elementList) infoTile(element),
                // removeItemButton(index),
              ]),
            ),
          ),
        );
      }

      Widget infoItemList() {
        final infoBody = viewModel.info.body;

        if (infoBody.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('情報を追加してください'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Column(
            children: [
              for (var index = 0; index < infoBody.length; index++) infoListItem(index),
            ],
          );
        }
      }

      Widget infoListCard() {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [Text('機密情報', style: style)],
                ),
                const SizedBox(height: 8),
                infoItemList(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    addButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Container(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  basicInfoCard(),
                  infoListCard(),
                  const SizedBox(height: 8),
                  sendbutton(),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
