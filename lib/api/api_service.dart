import 'package:dio/dio.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:retrofit/http.dart';
import '../bean/BaseResponseBean.dart';
import '../bean/DataBean.dart';
import '../ext/Ext.dart';
import '../http/dio_client.dart';
part "api_service.g.dart";

@RestApi()
abstract class ApiService {
  factory ApiService({Dio? dio, String? baseUrl}) {
    dio ??= DioClient().dio;
    return _ApiService(dio, baseUrl: baseUrl);
  }
  static const String _url =
  // "192.168.2.30";
      "47.243.120.137";

  static const String BASE_URL = "http://$_url/StandardAMS_V1.1.0_KaiShingICC_WebService/";

  static const String _asmx =
      "MobileWebService.asmx/";

  ///登录
  @POST(BASE_URL + _asmx + "GetCheckLogin")
  Future<List<DataBean>> GetCheckLogin(
    @Field("loginID") String loginID,
    @Field("userPwd") String userPwd,
    @Field("companyID") String companyID
  );

  //用户列表
  @POST(BASE_URL + _asmx + "userList")
  Future<BaseResponseBean<List<DataBean>>> userList(
    @Field("lastcalldate") String? lastcalldate,
    @Field("userid") String? userid,
    @Field("companyID") String? companyID
  );

  //物料出入仓列表 0出1入
  @POST(BASE_URL + _asmx + "getMaterialList")
  Future<List<DataBean>> getMaterialList(
    @Field("type") int type,
    @Field("userid") String? userid,
    @Field("companyID") String? companyID
  );

  //地址
  @POST(BASE_URL + _asmx + "getLocation_Material")
  Future<List<DataBean>> getLocationMaterial(
    @Field("userid") String? userid,
    @Field("companyID") String? companyID,
    @Field("mrono") String? mrono,
    @Field("batchno") String? batchno,
    @Field("type") int type,
  );

  //入库上传
  @FormUrlEncoded()
  @POST(BASE_URL + _asmx + "createMaterialInbound")
  Future<DataBean> createMaterialInbound(
    @Field("userid") String? userid,
    @Field("companyID") String? companyID,
    @Field("jsonData") String? jsonData,
    @Field("files") String? files,
    @Field("orderno") String orderno,
  );

  //出库上传
  @FormUrlEncoded()
  @POST(BASE_URL + _asmx + "createMaterialOutbound")
  Future<DataBean> createMaterialOutbound(
    @Field("userid") String? userid,
    @Field("companyID") String? companyID,
    @Field("jsonData") String? jsonData,
    @Field("files") String? files,
    @Field("orderno") String orderno,
  );

}
