import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/model/condition_model.dart';
import 'package:vaulton/view/form_screen/form_screen_vm.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final viewModel = ref.watch(formScreenViewModelProvider);
      var responceStr = '';

      void addInfo() {
        viewModel.addInfoItem(ref);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }

      Future<void> messageConfirmation() async {
        const title = '登録情報';
        const reviseText = '修正';
        const confirmText = '確定';

        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
              title: const Text(title),
              content: Text(viewModel.toMessage()),
              actions: [
                TextButton(
                  child: const Text(reviseText),
                  onPressed: () => Navigator.pop(context),
                ),
                TextButton(
                  child: const Text(confirmText),
                  onPressed: () async {
                    Navigator.of(context).pop();

                    addInfo();
                  },
                ),
              ],
            );
          },
        );
      }

      Widget formRow(Map<String, dynamic> formInfo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: viewModel.controllers[formInfo['name']],
            decoration: InputDecoration(labelText: formInfo['hint'] ?? formInfo['name']),
          ),
        );
      }

      Widget freeFormRow(formInfo) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            controller: viewModel.controllers[formInfo['name']],
            maxLines: null,
            minLines: 5,
            decoration: InputDecoration(
              hintText: formInfo['hint'] ?? formInfo['name'],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        );
      }

      Future<void> onFilePickTap() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result != null) {
          setState(() {
            viewModel.fileInBase64 = base64.encode(result.files.single.bytes!);
            viewModel.fileName = result.files.first.name;
          });
        } else {}
      }

      Widget filePickButton() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (viewModel.fileName != null)
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(Icons.attach_file_rounded, size: 18),
              ),
            Text(viewModel.fileName ?? '未選択'),
            const SizedBox(width: 18),
            ElevatedButton(
              child: const Padding(padding: EdgeInsets.all(8), child: Text('ファイルをアップロード')),
              onPressed: () async => onFilePickTap(),
            ),
          ],
        );
      }

      Widget passOrFileToggle(Map<String, dynamic> formInfo) {
        final list = ['キーファイル', 'パスワード'];
        final labelStyle = TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize!);
        const chipStyle = TextStyle(color: Colors.white);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('認証情報タイプ選択', style: labelStyle),
              const SizedBox(height: 4),
              ChoiceChip(
                selectedColor: Theme.of(context).primaryColor.withAlpha(182),
                label: Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(
                    list[0],
                    style: chipStyle,
                  ),
                ),
                selected: viewModel.withFile,
                onSelected: (bool selected) {
                  setState(() => viewModel.withFile = true);
                },
              ),
              const SizedBox(height: 8),
              ChoiceChip(
                selectedColor: Theme.of(context).primaryColor.withAlpha(182),
                label: Container(
                  width: 100,
                  alignment: Alignment.center,
                  child: Text(list[1], style: chipStyle),
                ),
                selected: !viewModel.withFile,
                onSelected: (bool selected) {
                  setState(() {
                    viewModel.withFile = false;
                  });
                },
              ),
            ],
          ),
        );
      }

      Widget formWidgetItem(Map<String, dynamic> formInfo) {
        if (formInfo['type'] == InfoType.file) {
          // ---------- ファイルフィールド ----------
          return filePickButton();
        } else if (formInfo['type'] == InfoType.passwordOrFile) {
          // ---------- ファイルまたはパスフィールド ----------
          return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            passOrFileToggle(formInfo),
            const SizedBox(width: 18),
            if (viewModel.withFile) Flexible(child: filePickButton()),
            if (!viewModel.withFile) Flexible(child: formRow(formInfo)),
          ]);
        } else if (formInfo['type'] == InfoType.free) {
          // ---------- 自由入力フィールド ----------
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: freeFormRow(formInfo),
          );
        } else {
          // ---------- その他フィールド ----------
          return formRow(formInfo);
        }
      }

      Widget formWidgetList(List<Map<String, dynamic>> formList) {
        return Column(children: [
          for (var index = 0; index < formList.length; index++) formWidgetItem(formList[index]),
        ]);
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Form(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  formWidgetList(viewModel.formList),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => messageConfirmation(),
                        child: const Padding(padding: EdgeInsets.all(8), child: Text('確定')),
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
        ),
      );
    });
  }
}
