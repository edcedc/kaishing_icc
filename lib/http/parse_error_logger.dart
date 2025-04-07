import 'package:dio/dio.dart';

// 定义 ParseErrorLogger 接口
abstract class ParseErrorLogger {
  void logError(Object error, [StackTrace? stackTrace, dynamic options]);
}