import 'package:flutter/material.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:get/get.dart';

import '../../utlis/language/Messages.dart';

class MyAlertDialog extends StatelessWidget {

  ///标题
  String title = '';

  ///内容
  String content = '';

  ///左侧文字
  String negaText = '';

  ///右侧文字
  String posiText = '';

  ///左侧事件
  VoidCallback? negaTap;

  ///右侧事件
  VoidCallback? posiTap;

  ///左侧是否隐藏
  bool negaVisible = true;

  ///右侧是否隐藏
  bool posiVisible = true;

  MyAlertDialog({
    Key? key,
    this.title = '',
    this.content = '',
    this.negaText = '',
    this.posiText = '',
    this.negaVisible = true,
    this.posiVisible = true,
    this.negaTap,
    this.posiTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title.isEmpty ? Globalization.appName.tr : title),
      content: Text(content, style: TextStyle(fontSize: 16),),
      actions: [
        if (negaVisible)
          TextButton(
            onPressed: () {
              Get.dismiss(); // 关闭对话框
              negaTap?.call();
            },
            child: Text(negaText.isEmpty ? Globalization.confirm.tr : negaText),
          ),
        if (posiVisible)
          TextButton(
            onPressed: () {
              Get.dismiss(); // 关闭对话框
              posiTap?.call();
            },
            child: Text(posiText.isEmpty ? Globalization.cancel.tr : posiText),
          ),
      ],
    );
  }
}