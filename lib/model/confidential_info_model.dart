class ConfidentialInfo {
  ConfidentialInfo();
  var cliant = '';
  var project = '';
  List<ConfidentialInfoItem> body = [];

  void clear() {
    cliant = '';
    project = '';
    body = [];
  }

  String toMultiLineString() {
    var output = '## 基本情報\n\n';
    output += 'クライアント：$cliant\n';
    output += 'プロジェクト：$project\n\n';
    output += '---\n';

    for (var element in body) {
      output += '\n';
      output += element.toMultiLineString();
    }

    return output;
  }

  @override
  String toString() {
    return {
      'cliant': cliant,
      'project': project,
      'body': body,
    }.toString();
  }
}

class ConfidentialInfoItem {
  ConfidentialInfoItem(this.serviceTitle);
  List<InfoElement> elementList = [];
  String serviceTitle;
  String? fileName;
  String? fileInBase64;

  String toMultiLineString() {
    var output = '';
    output += '## $serviceTitle\n\n';
    for (var element in elementList) {
      output += '- ${element.key}: ${element.value}\n';
    }
    output += '';
    return output;
  }

  @override
  String toString() {
    return {
      'fileName': fileName,
      'fileInBase64': fileInBase64 != null,
      'elementList': elementList,
    }.toString();
  }
}

class InfoElement {
  String key = '';
  String value = '';

  @override
  String toString() {
    return '$key: $value';
  }
}
