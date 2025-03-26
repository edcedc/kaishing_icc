import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:path/path.dart' as p;

import 'package:fyyc/utlis/mixin/log/LogUtils.dart';

class Base64Utils {
  Future<String> convertFilesToBase64(List<File> listFile) async {
    final receivePort = ReceivePort(); // 创建接收端口
    final completer = Completer<String>(); // 创建 Completer 用于返回结果

    // 启动 Isolate
    await Isolate.spawn(_convertFilesToBase64InBackground, [receivePort.sendPort, listFile]);

    // 监听 Isolate 发送的消息
    receivePort.listen((message) {
      if (message is String) {
        completer.complete(message); // 完成 Future
      }
    });

    return completer.future; // 返回 Future
  }

  static void _convertFilesToBase64InBackground(List<dynamic> args) {
    final sendPort = args[0] as SendPort; // 获取发送端口
    final listFile = args[1] as List<File>; // 获取文件列表

    List<String> base64List = [];
    for (File file in listFile) {

      // var fileExtension = _getFileExtension(file.toString());
      String fileExtension = p.extension(file.toString()).toLowerCase();
      List<int> fileBytes = file.readAsBytesSync(); // 同步读取文件内容
      String base64String = base64Encode(fileBytes); // 转换为 Base64
      if(fileExtension.contains('.pdf')){
        base64String = 'data:application/pdf;' + base64String;
      }
      base64List.add(base64String); // 添加到列表
    }

    String result = base64List.join(","); // 拼接为字符串
    sendPort.send(result); // 发送结果
  }


  static String _getFileExtension(String filePath) {
    // 使用 split 方法分割路径，并获取最后一个部分（文件名）
    String fileName = filePath.split('/').last;

    // 再次使用 split 方法分割文件名，获取扩展名
    String fileExtension = fileName.split('.').last;

    return fileExtension;
  }

}