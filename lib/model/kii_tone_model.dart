import 'package:flutter/material.dart';

void showNetworkingCircular(BuildContext context) {
  showDialog(
    barrierDismissible: false, // 周辺タップで戻らない
    context: context,
    builder: (_) {
      return WillPopScope(
        onWillPop: () async => false, // 戻るボタンで戻らない
        child: const SimpleDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.all(0),
          insetPadding: EdgeInsets.all(0),
          children: [
            Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ],
        ),
      );
    },
  );
}
