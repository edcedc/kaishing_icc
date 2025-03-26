import 'package:logger/logger.dart';

class LogUtils {
  LogUtils._(); // 私有构造函数
  factory LogUtils() => LogUtils._(); // factory constructor
  static void e(String message) {
    var logger = Logger(
      printer: PrettyPrinter(
          methodCount: 2, // Number of method calls to be displayed
          errorMethodCount: 8, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: false // Should each log print contain a timestamp
      ),
      filter: MyLogerFilter(),
    );
    logger.e(message);
  }
}

class MyLogerFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // 在这里定义日志过滤逻辑
    return true; // 返回 true 表示允许打印日志，返回 false 表示禁止打印日志
  }
}