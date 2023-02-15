import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/model/condition_model.dart';
import 'package:vaulton/model/confidential_info_model.dart';
import 'package:vaulton/view/info_list_screen/info_list_screen_vm.dart';

final formScreenViewModelProvider = StateProvider((ref) => FormScreenViewModel());

class FormScreenViewModel {
  var serviceTitle = '';
  var controllers = <String, TextEditingController>{};
  var formList = <Map<String, dynamic>>[];
  var withFile = true;
  String? fileInBase64;
  String? fileName;
  Map<String, dynamic> formInfoMap = {};

  void initialize({required String serviceTitle, required List<Map<String, dynamic>> formList}) {
    this.serviceTitle = serviceTitle;
    this.formList = formList;
    withFile = true;
    fileName = null;
    fileInBase64 = null;

    controllers = {};
    for (var form in formList) {
      controllers[form['name']] = TextEditingController();
    }
  }

  void resetControllers() {
    controllers.forEach((key, value) {
      controllers[key]!.clear();
      fileInBase64 = null;
      fileName = null;
    });
  }

  Map<String, String> formInfoToMap() {
    var output = <String, String>{};
    for (var form in formList) {
      if (form['type'] == InfoType.passwordOrFile) {
        if (withFile) {
          output[form['name']] = fileName ?? 'ファイル未登録';
        } else {
          output['パスワード'] = controllers[form['name']]!.text;
        }
      } else if (form['type'] == InfoType.file) {
        output[form['name']] = fileName ?? 'ファイル未登録';
      } else {
        output[form['name']] = controllers[form['name']]!.text;
      }
    }
    return output;
  }

  ConfidentialInfoItem formInfo() {
    final item = ConfidentialInfoItem(serviceTitle);
    item.fileName = fileName;
    item.fileInBase64 = fileInBase64;

    for (var index = 0; index < formList.length; index++) {
      final element = InfoElement();
      final form = formList[index];
      final isFile =
          form['type'] == InfoType.file || (form['type'] == InfoType.passwordOrFile && withFile);
      if (!isFile) {
        if (form['type'] == InfoType.passwordOrFile || form['type'] == InfoType.password) {
          element.key = 'パスワード';
        } else {
          element.key = form['name']!;
        }
        element.value = controllers[form['name']!]!.text;
        item.elementList.add(element);
      } else {
        element.key = 'キーファイル';
        element.value = fileName ?? '未選択';
        item.elementList.add(element);
      }
    }

    return item;
  }

  void addInfoItem(WidgetRef ref) {
    final infoListScreenVM = ref.watch(infoListScreenViewModelProvider);
    infoListScreenVM.info.body.add(formInfo());
  }

  String issueSubject() {
    return '情報登録依頼 [ ${controllers['クライアント名']!.text} - ${controllers['プロジェクト名']!.text} - $serviceTitle ]';
  }

  String toMessage() {
    final map = formInfoToMap();
    var output = "";
    map.forEach((key, value) {
      output += '$key : $value\n';
      if (key == 'プロジェクト名') {
        output += '情報タイプ : $serviceTitle\n';
      } else if (key == '') {}
    });
    return output;
  }
}
