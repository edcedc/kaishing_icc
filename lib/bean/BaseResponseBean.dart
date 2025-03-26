
import 'package:json_annotation/json_annotation.dart';

part 'BaseResponseBean.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseBean<T>{
  @JsonKey(name: "code")
  int? code;
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "msg")
  String? msg;
  @JsonKey(name: "data")
  T? data;

  BaseResponseBean({this.code, this.count, this.msg, this.data});

  factory BaseResponseBean.fromJson(
      Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseBeanFromJson(json, fromJsonT);


  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$BaseResponseBeanToJson(this, toJsonT);

}