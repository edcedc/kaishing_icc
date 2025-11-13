
import 'package:fyyc/bean/DataBean.dart';
import 'package:fyyc/ui/login/login_logic.dart';
import 'package:fyyc/ui/main/main_view.dart';
import 'package:fyyc/ui/setting/setting_view.dart';
import 'package:fyyc/ui/start_page.dart';
import 'package:get/get.dart';

import '../image_page.dart';
import '../ui/login/login_view.dart';
import '../ui/main/material/item_address/item_address_view.dart';
import '../ui/main/material/material_details/material_details_view.dart';
import '../ui/main/material/material_entry/material_entry_logic.dart';
import '../ui/main/material/material_entry/material_entry_view.dart';
import '../ui/main/material/material_exit/material_exit_view.dart';

class UIHelper{

  //登录
  static void startLogin(){
      // Get.offAllNamed(login);
      Future.delayed(Duration(seconds: 1), () {
        Get.offAllNamed(_login);
      });
  }

  //main
  static void startMain(){
      // Get.offAllNamed(main);
      Future.delayed(Duration(seconds: 1), () {
        Get.offAllNamed(_main);
      });
  }

  //图片
  static void startImage(int index, List<DataBean> images){
    Get.toNamed(_image, arguments: {'index': index, 'images': images});
  }

  //设置
  static void startSetting(){
    Get.toNamed(_setting);
  }

  //物料详情
  static void startMaterialDetailsPage(DataBean bean, int index){
    Get.toNamed(_materialDetailsPage, arguments: {'bean': bean, 'index': index});
  }

  //物料选择地址
  static void startItemAddressPage(DataBean bean){
    Get.toNamed(_itemAddressPage, arguments: {'bean': bean}, preventDuplicates: false,);
  }

  static const _login = '/login';
  static const start = '/start';
  static const _setting = '/setting';
  static const _main = '/main';
  static const _image = '/image';
  static const _materialDetailsPage = '/materialDetailsPage';
  static const _itemAddressPage = '/ItemAddressPage';

  static List<GetPage> getPages = [
    GetPage(name: start, page: () => StartPage()),
    GetPage(name: _login, page: () => LoginPage(), transition: Transition.rightToLeftWithFade),
    GetPage(name: _setting, page: () => SettingPage(), transition: Transition.rightToLeftWithFade),
    GetPage(name: _main, page: () => MainPage(), transition: Transition.rightToLeftWithFade),
    GetPage(name: _materialDetailsPage, page: () => MaterialDetailsPage(), transition: Transition.rightToLeftWithFade),
    GetPage(name: _image, page: () => ImagePage(), transition: Transition.rightToLeftWithFade),
    GetPage(name: _itemAddressPage, page: () => ItemAddressPage(), transition: Transition.rightToLeftWithFade),
  ];

  static void closePage(){
    Get.back();
  }

}