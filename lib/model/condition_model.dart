import 'package:flutter/material.dart';

class FormTypeList {
  static List<Map<String, dynamic>> values = [
    {
      'title': 'Webサーバー情報',
      'subTitle': 'AWS EC2・Azure VMなど',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': 'サイトURL', 'type': InfoType.url},
        {'name': 'Basic ID', 'type': InfoType.text, 'hint': 'Basic ID (Basic認証をかけている場合)'},
        {'name': 'Basicパスワード', 'type': InfoType.password, 'hint': 'Basicパスワード (Basic認証をかけている場合)'},
        {'name': 'ホスト情報 (IPアドレスまたはDNS名)', 'type': InfoType.text, 'hint': 'IPアドレスまたはDNS名'},
        {'name': '認証情報 - パスワードまたはキーファイル', 'type': InfoType.passwordOrFile, 'hint': 'パスワード'},
        {'name': 'メモ', 'type': InfoType.free, 'hint': '追加情報がある場合は記載'},
      ],
      'description': 'Webサイトのサーバー情報(SSH・FTP情報)と、サイトURLや認証情報を併せて登録',
    },
    {
      'title': '他SSH・FTP情報',
      'subTitle': 'AWS EC2・Azure VMなど',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': 'ホスト情報 - IPアドレスまはたDNS名', 'type': InfoType.text, 'hint': 'IPアドレスまたはDNS名'},
        {'name': '認証情報 - パスワードまたはキーファイル', 'type': InfoType.passwordOrFile, 'hint': 'パスワード'},
        {'name': 'メモ', 'type': InfoType.free, 'hint': '追加情報がある場合は記載'},
      ],
      'description': 'ホスト情報＋認証情報\n例1：IPアドレス＋pemファイル\n例2：DNS名＋パスワード',
    },
    {
      'title': 'DB接続情報',
      'subTitle': 'phpMyAdminなど',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': 'URL', 'type': InfoType.url, 'hint': 'ログインページURL'},
        {'name': 'Basic ID', 'type': InfoType.text, 'hint': 'Basic ID (Basic認証をかけている場合)'},
        {'name': 'Basicパスワード', 'type': InfoType.password, 'hint': 'Basicパスワード (Basic認証をかけている場合)'},
        {'name': 'ログインID', 'type': InfoType.text},
        {'name': 'パスワード', 'type': InfoType.password},
        {'name': 'メモ', 'type': InfoType.free, 'hint': 'アカウントに関する説明や使用用途\nその他ログイン時に知っておくべき情報があれば記載'},
      ],
      'description': 'IP/PW＋Basicで認証するものはDB以外でもこちらを利用可能'
    },
    {
      'title': 'サービス・アプリログイン情報 A',
      'subTitle': 'IDとパスで認証するもの全般',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': 'URL', 'type': InfoType.url, 'hint': 'ログインページURL'},
        {'name': 'ログインID, EmailまたはTEL', 'type': InfoType.text},
        {'name': 'パスワード', 'type': InfoType.password},
        {'name': 'メモ', 'type': InfoType.free, 'hint': 'アカウントに関する説明や使用用途\nその他ログイン時に知っておくべき情報があれば記載'},
      ],
      'description': '''企業名義のアカウント
SNSを含む個人名義のアカウント
AWSコンソール, WordPressアカウントなど
テストサイトのBasic認証単体であればRedmineのWikiでの管理も可能'''
    },
    {
      'title': 'サービス・アプリログイン情報 B',
      'subTitle': '2段階認証があるもの',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': 'URL', 'type': InfoType.url, 'hint': 'ログインページURL'},
        {'name': 'ログインID, EmailまたはTEL', 'type': InfoType.text},
        {'name': 'パスワード', 'type': InfoType.password},
        {'name': 'EmailまたはTEL', 'type': InfoType.text, 'hint': '2段階認証に使うEmailまたはTEL'},
        {'name': 'メモ', 'type': InfoType.free, 'hint': 'アカウントに関する説明や使用用途\nその他ログイン時に知っておくべき情報があれば記載'},
      ],
      'description': '2段階認証にログインID以外を設定している場合はこちら\nログインIDが2段階認証のアドレスになっている場合はAを利用'
    },
    {
      'title': 'その他',
      'subTitle': '上記にない、または該当項目が不明な場合',
      'forms': [
        // {'name': 'クライアント名', 'type': InfoType.text},
        // {'name': 'プロジェクト名', 'type': InfoType.text},
        {'name': '自由入力', 'type': InfoType.free, 'hint': 'わかっている情報や特記事項を全て記載'},
        {'name': 'キーファイル', 'type': InfoType.file},
      ],
      'description': '該当項目が見つからない場合や、いずれのフォームにも当てはまらない場合はこちらを選択'
    },
  ];
}

enum InfoType {
  text,
  email,
  url,
  number,
  password,
  file,
  passwordOrFile,
  free,
}

extension InfoTypeExtension on InfoType {
  TextInputType get keyboardType {
    switch (this) {
      case InfoType.text:
        return TextInputType.text;
      case InfoType.email:
        return TextInputType.emailAddress;
      case InfoType.url:
        return TextInputType.url;
      case InfoType.number:
        return TextInputType.number;
      case InfoType.password:
        return TextInputType.visiblePassword;
      case InfoType.file:
        return TextInputType.none;
      case InfoType.passwordOrFile:
        return TextInputType.visiblePassword;
      case InfoType.free:
        return TextInputType.text;
    }
  }
}
