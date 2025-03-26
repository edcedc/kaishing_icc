// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseResponseBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponseBean<T> _$BaseResponseBeanFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    BaseResponseBean<T>(
      code: (json['code'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
      msg: json['msg'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
    );

Map<String, dynamic> _$BaseResponseBeanToJson<T>(
  BaseResponseBean<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'count': instance.count,
      'msg': instance.msg,
      'data': _$nullableGenericToJson(instance.data, toJsonT),
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
