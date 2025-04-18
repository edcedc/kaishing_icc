import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../app_except.dart';

///错误处理拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // error统一处理
    AppException appException = AppException.create(err);
    // 错误提示
    print('DioError===: ${appException.toString()}');
    // err.error = appException;
    super.onError(err, handler);
  }
}
