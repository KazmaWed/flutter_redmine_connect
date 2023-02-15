import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaulton/model/base64_file.dart';
import 'package:vaulton/model/confidential_info_model.dart';
import 'package:vaulton/repository/redmine_repository.dart';

final infoListScreenViewModelProvider = StateProvider((ref) => InfoListScreenViewModel());

class InfoListScreenViewModel {
  final repository = RedmineRepository();
  final info = ConfidentialInfo();
  final cliantController = TextEditingController();
  final projectController = TextEditingController();

  void init() {
    info.clear();
    cliantController.clear();
    projectController.clear();
  }

  void removeInfoItem(WidgetRef ref, int at) {
    final infoListScreenVM = ref.watch(infoListScreenViewModelProvider);
    infoListScreenVM.info.body.removeAt(at);
  }

  String createMessage() {
    var output = '';

    output += '**クライアント**\n${cliantController.text}\n';
    output += '**プロジェクト**\n${projectController.text}\n';

    // 機密情報アイテム
    for (var item in info.body) {
      output += '\n**${item.serviceTitle}**\n';
      for (var element in item.elementList) {
        output += '${element.key}: ${element.value}\n';
      }
    }

    return output;
  }

  Future<bool> gasPost() async {
    final idToken = await FirebaseAuth.instance.currentUser!.getIdToken();
    final fileList = <Base64File>[];
    var succeed = true;

    for (var item in info.body) {
      if (item.fileName != null && item.fileInBase64 != null) {
        final base64File = Base64File(fileName: item.fileName!, fileInBase64: item.fileInBase64!);
        fileList.add(base64File);
      }
    }

    await repository
        .gasPost(
      subject: issueSubject(),
      message: createMessage(),
      fileList: fileList,
      idToken: idToken,
    )
        .then((value) {
      if (value == RedmineRepository.postFailResponceText ||
          value == RedmineRepository.loginFailResponceText) {
        succeed = false;
      }
    });

    return succeed;
  }

  String issueSubject() {
    return '情報登録依頼 [ ${cliantController.text} - ${projectController.text} ]';
  }
}
