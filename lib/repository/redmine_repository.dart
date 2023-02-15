import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vaulton/model/base64_file.dart';

// 新しいチケットを作成
class RedmineRepository {
  static const loginFailResponceText = 'LOGIN FAILED';
  static const postFailResponceText = 'POST FAILED';

  Future<String> myAccount() async {
    const baseUrl = 'https://pm.tongullman.com/';
    const format = 'my/account.json';
    const url = '$baseUrl$format';

    var responce = await http.get(Uri.parse(url));
    return jsonDecode(responce.body);
  }

  Future<String> gasPost({
    required String subject,
    required String message,
    required List<Base64File> fileList,
    required String idToken,
  }) async {
    const baseUrl =
        'https://script.google.com/macros/s/AKfycbwHQm0f3P7gRNk1jonWaFjWfm0pDRCm90F17CI_AfBkaTJ64EQnJPN9MfCFoFjBpfI/exec';
    var url = '$baseUrl?idToken=$idToken&subject=$subject&message=$message';

    var publicMessage = '情報管理チームへの登録依頼が完了したことをお知らせするチケットです。\n';
    publicMessage += '\n';
    publicMessage += 'お送りいただいた情報はID ManagerまたはKeePassXで保管し利用してください。\n';
    publicMessage += '(txtファイルやメモ帳などによる管理をしないでください)\n';
    publicMessage += '\n';
    publicMessage += '情報管理チームが手続きが完了したら、このチケットを終了します。';

    url += '&public_message=$publicMessage';

    late http.Response response;

    if (fileList.isNotEmpty) {
      final fileListEncodable = fileList.map((e) {
        return e.toMap();
      }).toList();

      response = await http.post(
        Uri.parse(url),
        body: json.encode(fileListEncodable).toString(),
        encoding: Encoding.getByName("utf-8"),
      );
    } else {
      response = await http.post(
        Uri.parse(url),
        encoding: Encoding.getByName("utf-8"),
      );
    }

    return response.body;
  }
}
