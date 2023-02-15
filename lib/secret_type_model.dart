import 'package:flutter/material.dart';

class ConfidentialInfoType {
  ConfidentialInfoType({
    required this.title,
    required this.sampleServiceList,
    required this.formList,
  });
  String title;
  List<String> sampleServiceList;
  List<Map<String, dynamic>> formList;
}

List<ConfidentialInfoType> secretTypeList = [
  ConfidentialInfoType(
    title: 'AWS',
    sampleServiceList: ['AWS', 'FTP'],
    formList: [
      {'name': 'クライアント', 'type': TextInputType.text},
      {'name': 'プロジェクト', 'type': TextInputType.text},
      {'name': 'IP Address', 'type': TextInputType.text},
      {'name': 'ID', 'type': TextInputType.text},
      {'name': 'Password', 'type': TextInputType.visiblePassword},
      {'name': 'KeyFile', 'type': 'keyFile'}
    ],
  ),
  ConfidentialInfoType(
    title: 'SNSタイプ1',
    sampleServiceList: ['Twitter', 'Instagram'],
    formList: [
      {'name': 'クライアント', 'type': TextInputType.text},
      {'name': 'プロジェクト', 'type': TextInputType.text},
      {'name': 'ID', 'type': TextInputType.text},
      {'name': 'Password', 'type': TextInputType.visiblePassword},
    ],
  ),
  ConfidentialInfoType(
    title: 'SNSタイプ2',
    sampleServiceList: ['Facebook', 'Instagram'],
    formList: [
      {'name': 'クライアント', 'type': TextInputType.text},
      {'name': 'プロジェクト', 'type': TextInputType.text},
      {'name': 'Email', 'type': TextInputType.text},
      {'name': 'Password', 'type': TextInputType.visiblePassword},
    ],
  )
];
