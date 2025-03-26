import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {

  Widget onCread(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // 这里可以放置共享的状态和逻辑
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: onCread(context),
    );
  }

  void showSnackbar(String title, String desc) {
    Get.snackbar(title, desc,
      duration: Duration(
          seconds: 2
      ),
      isDismissible: true,
    );
  }

  void showOutDialog() {
    Get.defaultDialog(
        title: "提示",
        middleText: "您确定退出登录？",
        confirm: ElevatedButton(
            onPressed: () {
              print("确定");
              Get.back();
            },
            child: const Text("确定")),
        cancel: ElevatedButton(
            onPressed: () {
              print("取消");
              Get.back();
            },
            child: const Text("取消")));
  }

}