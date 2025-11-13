import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:fyyc/api/api_service.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../ext/Ext.dart';
import 'interceptor/error_interceptor.dart';
import 'interceptor/http_params_interceptor.dart';

////Dio客户端
class DioClient {
  static void initClient({
    required String baseUrl,
    List<Interceptor>? interceptors,
  }) {
    DioClient().init(
      baseUrl: baseUrl,
      interceptors: interceptors,
    );
  }

  ///超时时间
  Duration _connectTimeout = const Duration(seconds: 10);
  Duration _receiveTimeout = const Duration(seconds: 10);
  Duration _sendTimeout = const Duration(seconds: 10);

  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = BaseOptions(
      responseType: ResponseType.json,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      connectTimeout: _connectTimeout,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      // baseUrl: ApiService.BASE_URL,
      // baseUrl: SharedUtils.getString(BASE_URL),
      // Http请求头.
      headers: _httpHeaders,
    );

    dio = Dio(options);

    // 添加error拦截器
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(HttpParamsInterceptor());
    dio.interceptors.add(PrettyDioLogger(
      // 添加日志格式化工具类
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

    // 在调试模式下需要抓包调试，所以我们使用代理，并禁用HTTPS证书校验
    if (false) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.findProxy = (uri) {
          // return "PROXY $PROXY_IP:$PROXY_PORT";
          return "proxy";
        };
        //代理工具会提供一个抓包的自签名证书，会通不过证书校验，所以我们禁用证书校验
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
    }
  }

  /// 自定义Header
  Map<String, dynamic> _httpHeaders = {
    'Accept': 'application/json,*/*',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  void init({
    String? baseUrl,
    Map<String, String>? headers,
    List<Interceptor>? interceptors,
  }) {
    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      // baseUrl: ApiService.BASE_URL,
      // Http请求头.
      headers: _httpHeaders,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }
}
