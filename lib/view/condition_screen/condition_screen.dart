import 'package:flutter/material.dart';
import 'package:vaulton/model/condition_model.dart';
import 'package:vaulton/view/form_screen/form_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/view/form_screen/form_screen_vm.dart';

class ConditionScreen extends ConsumerWidget {
  const ConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(formScreenViewModelProvider);

    void onTapItem({required String title, required List<Map<String, dynamic>> formList}) {
      viewModel.initialize(serviceTitle: title, formList: formList);

      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return FormScreen(title: title);
      }));
    }

    Widget listItem(int index) {
      final String title = FormTypeList.values[index]['title'];
      final String subTitle = FormTypeList.values[index]['subTitle'];
      final List<Map<String, dynamic>> formList = FormTypeList.values[index]['forms'];

      final titleStyel = TextStyle(
        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        color: Theme.of(context).primaryColor,
      );
      final subTitleStyel = TextStyle(
        fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
        color: Colors.black54,
      );
      final smallLabelStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
        color: Colors.black54,
      );

      Widget formIcon(String text) {
        const style = TextStyle(color: Colors.white);
        return Container(
          // clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
          child: Material(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            color: Colors.white,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              color: Theme.of(context).primaryColor.withAlpha(182),
              child: Text(text, style: style),
            ),
          ),
        );
      }

      return Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
            onTap: () => onTapItem(title: title, formList: formList),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(title, style: titleStyel),
                  const SizedBox(width: 12),
                  Flexible(child: Text(subTitle, style: subTitleStyel, maxLines: null)),
                ]),
                const SizedBox(height: 4),
                const Divider(height: 12),
                Row(children: [Text('登録する情報', style: smallLabelStyle)]),
                const SizedBox(height: 4),
                Row(children: [
                  Flexible(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var formIdx = 0; formIdx < formList.length; formIdx++)
                          formIcon(formList[formIdx]['name']),
                      ],
                    ),
                  ),
                ]),
                const Divider(height: 18),
                Row(children: [
                  Flexible(
                      child: Text(
                    FormTypeList.values[index]['description'],
                    maxLines: null,
                  )),
                ])
              ]),
            )),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('情報のタイプを選択'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  for (var index = 0; index < FormTypeList.values.length; index++) listItem(index),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
