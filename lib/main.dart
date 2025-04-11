import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'api/api_service.dart';
import 'mar/MyApplication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initSDK();
  runApp(const MyApplication());
}

/// 初始化 SDK
Future<void> initSDK() async {
  await SharedUtils.getInstance(); // 确保 SharedUtils 初始化完成
  await Injection().init();
}

///初始化注入对象
class Injection extends GetxService {
  Future<void> init() async {
    Get.lazyPut(() => ApiService(), fenix: true);
  }
}

//
