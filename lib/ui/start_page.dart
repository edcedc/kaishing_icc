import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/base/BaseState.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_service.dart';
import '../bean/DataBean.dart';
import '../ext/Ext.dart';
import '../ext/Ext.dart';
import '../utlis/PermissionHelper.dart';
import '../utlis/SharedUtils.dart';
import 'login/login_view.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends BaseState<StartPage> {

  @override
  void initState() {
    super.initState();
    // setPermissions();
    var url = SharedUtils.getString(BASE_URL) ?? "";
    if (url.isEmpty) {
       SharedUtils.setString(BASE_URL, ApiService.BASE_URL);
    }
    var companyId = SharedUtils.getString(COMPANY_ID) ?? "";
    if (companyId.isEmpty) {
      SharedUtils.setString(COMPANY_ID, 'ICC');
    }

    _getSharedLo();

    var string = SharedUtils.getString(USER_DATA);
    if(!string.isEmpty){
      DataBean bean = DataBean.fromJson(json.decode(string));
      if(bean != null && bean.loginID != null && bean.password != null){
        UIHelper.startMain();
      }else{
        UIHelper.startLogin();
      }
    }else{
      UIHelper.startLogin();
    }
  }

  @override
  Widget onCread(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        'drawable/images/splash.png',
        fit: BoxFit.fill,
      ),
    );;
  }

  void setPermissions() {
    List<Permission> permissions = [
      Permission.storage,
      Permission.camera
    ];
    PermissionHelper.check(permissions,
        onSuccess: ()  {
          UIHelper.startLogin();
        }, onFailed: () {
          setPermissions();
        }, onOpenSetting: () {
          // logger.e('onOpenSetting');
          openAppSettings();
        });
  }


  var locale = Locale('en', 'US');

  Future<void> _getSharedLo() async {
    int? index = SharedUtils.getInt(SHARE_LANGUAGE); // 获取整数值
    switch (index) {
      case 0:
        locale = Locale('zh', 'CN');
      case 1:
        locale = Locale('zh_HK', 'HK');
      case 2:
        locale = Locale('en', 'US');
      default:
        locale = Locale('zh_HK', 'HK');
    }
    Get.updateLocale(locale);
  }

}
