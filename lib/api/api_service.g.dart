// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element

class _ApiService implements ApiService {
  _ApiService(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<List<DataBean>> GetCheckLogin(
    String loginID,
    String userPwd,
    String companyID,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'loginID': loginID,
      'userPwd': userPwd,
      'companyID': companyID,
    };
    final _options = _setStreamType<List<DataBean>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/GetCheckLogin',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DataBean> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => DataBean.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      
      rethrow;
    }
    return _value;
  }

  @override
  Future<BaseResponseBean<List<DataBean>>> userList(
    String? lastcalldate,
    String? userid,
    String? companyID,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'lastcalldate': lastcalldate,
      'userid': userid,
      'companyID': companyID,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<BaseResponseBean<List<DataBean>>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/userList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late BaseResponseBean<List<DataBean>> _value;
    try {
      _value = BaseResponseBean<List<DataBean>>.fromJson(
        _result.data!,
        (json) => json is List<dynamic>
            ? json
                .map<DataBean>(
                    (i) => DataBean.fromJson(i as Map<String, dynamic>))
                .toList()
            : List.empty(),
      );
    } on Object catch (e, s) {
      
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DataBean>> getMaterialList(
    int type,
    String? userid,
    String? companyID,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'type': type,
      'userid': userid,
      'companyID': companyID,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<List<DataBean>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/getMaterialList',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DataBean> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => DataBean.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<DataBean>> getLocationMaterial(
    String? userid,
    String? companyID,
    String? mrono,
    String? batchno,
    int type,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'userid': userid,
      'companyID': companyID,
      'mrono': mrono,
      'batchno': batchno,
      'type': type,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<List<DataBean>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/getLocation_Material',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<DataBean> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => DataBean.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataBean> createMaterialInbound(
    String? userid,
    String? companyID,
    String? jsonData,
    String? files,
    String orderno,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'userid': userid,
      'companyID': companyID,
      'jsonData': jsonData,
      'files': files,
      'orderno': orderno,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<DataBean>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
          _dio.options,
          '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/createMaterialInbound',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataBean _value;
    try {
      _value = DataBean.fromJson(_result.data!);
    } on Object catch (e, s) {
      
      rethrow;
    }
    return _value;
  }

  @override
  Future<DataBean> createMaterialOutbound(
      String? userid,
      String? companyID,
      String? jsonData,
      String? files,
      String orderno,
      ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = {
      'userid': userid,
      'companyID': companyID,
      'jsonData': jsonData,
      'files': files,
      'orderno': orderno,
    };
    _data.removeWhere((k, v) => v == null);
    final _options = _setStreamType<DataBean>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'application/x-www-form-urlencoded',
    )
        .compose(
      _dio.options,
      '${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/createMaterialOutbound',
      queryParameters: queryParameters,
      data: _data,
    )
        .copyWith(
        baseUrl: _combineBaseUrls(
          _dio.options.baseUrl,
          baseUrl,
        )));
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late DataBean _value;
    try {
      _value = DataBean.fromJson(_result.data!);
    } on Object catch (e, s) {

      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
