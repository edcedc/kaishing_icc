import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_service.dart';
import '../../base/controller/base_refresh_controller.dart';
import '../../bean/BaseResponseBean.dart';
import '../../bean/DataBean.dart';
import '../../ext/Ext.dart';
import '../../res/language/Messages.dart';
import '../../utlis/mixin/log/LogUtils.dart';
import '../../widgets/dialog/dialog_alert.dart';

class LoginLogic extends BaseRefreshController<ApiService> {

  var account = ''.obs; // 使用 RxString 来存储文本值
  var pwd = ''.obs; // 使用 RxString 来存储文本值

  var version = ''.obs;

  @override
  void onReady() {
    super.onReady();
    showSuccess();
    _fetchPackageInfo();
    _initAccountPwd();
  }
  
  void _initAccountPwd(){
    var string = SharedUtils.getString(USER_DATA);
    if(!string.isEmpty){
      DataBean bean = DataBean.fromJson(json.decode(string));
      account.value = bean.loginID!;
      // pwd.value = bean.password!;
    }
  }

  Future<void> _fetchPackageInfo() async {
    var fromPlatform = await PackageInfo.fromPlatform();
    var version2 = fromPlatform.version;
    version.value = "Version：$version2 ◎SPIT.";
  }

  void onlogin() {
    if(account.value.isEmpty || pwd.value.isEmpty){
      Get.dialog(
        MyAlertDialog(
          content: Globalization.text2.tr, // 对话框内容
          posiVisible: false,
        ),
      );
      return;
    }
    Get.showLoading();
    httpRequest<List<DataBean>>(api.GetCheckLogin(account.value, pwd.value, SharedUtils.getString(COMPANY_ID)!), (value) {
      Get.dismiss();
      bool allStatusZero = value.every((bean) => bean.status != '2');
      if(allStatusZero){
        Get.dialog(
          MyAlertDialog(
            content: Globalization.text3.tr,
            posiVisible: false,
          ),
        );
        return;
      }
      userList();
    }, showLoading: false, handleError: false);
  }

  void userList() {
    httpRequest<BaseResponseBean<List<DataBean>>>(api.userList('', account.value, SharedUtils.getString(COMPANY_ID)!), (value) {
      var list = value.data!;
      var bean = list.firstWhere((bean) => bean.loginID?.toLowerCase() == account.value.toLowerCase());
      if (bean != null) {
        bean.password = pwd.value;
        bean.companyID = SharedUtils.getString(COMPANY_ID);
        SharedUtils.setString(USER_DATA, json.encode(bean.toJson()));
        UIHelper.startMain();
      }
    }, showLoading: false);
  }

  @override
  void onHidden() {
  }

}



