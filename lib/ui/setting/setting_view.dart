import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/api/api_service.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:fyyc/widgets/DropdownLanguageWeight.dart';
import 'package:fyyc/widgets/dialog/dialog_common_style.dart';
import 'package:get/get.dart';

import '../../base/pageWidget/base_stateless_widget.dart';
import '../../ext/Ext.dart';
import '../../res/colors.dart';
import '../../res/language/Messages.dart';
import '../../widgets/CustomIconButton.dart';
import '../../widgets/TextFieldWeight1.dart';
import '../../widgets/dialog/dialog_alert.dart';
import 'setting_logic.dart';

class SettingPage extends BaseStatelessWidget<SettingLogic> {
  SettingPage({Key? key}) : super(key: key);

  final logic = Get.put(SettingLogic());

  @override
  bool showTitleBar() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFCCCCCC), // 状态栏颜色
      statusBarIconBrightness: Brightness.dark, // 状态栏图标亮度
    ));
    String url = logic.url.value;
    String companyId = logic.company_id.value;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            Expanded(child: ListView(children: [
              Row(
                children: [
                  CustomIconButton(
                    iconData: Icons.arrow_back_outlined,
                    size: 40,
                    onTap: () {
                      UIHelper.closePage();
                    },
                  ),
                ],
              ),
              Container(
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('drawable/images/icon_logo.png', height: 130, width: 130),
                    SizedBox(height: 20),
                    Text(Globalization.appName, style: TextStyle(fontSize: 30, color: ColorStyle.color_777777)),
                    Text(Globalization.material.tr, style: TextStyle(fontSize: 18, color: ColorStyle.color_777777)),
                    SizedBox(height: 20),
                    Divider(color: Colors.grey[500], thickness: 1),
                    SizedBox(height: 20),
                    DropdownLanguageWeight(),
                    SizedBox(height: 10),
                    Obx(() => TextField(
                        controller: TextEditingController(text: logic.url.value),
                        decoration: InputDecoration(
                            hintText: Globalization.url.tr,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                            border: OutlineInputBorder(
                            )
                        ),
                        onChanged: (text) {
                          url = text;
                        }
                    )),
                    SizedBox(height: 10),
                    Obx(() => TextField(
                        controller: TextEditingController(text: logic.company_id.value),
                        decoration: InputDecoration(
                            hintText: Globalization.company_id.tr,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0), // 设置左右内间距为 20，上下内间距为 0
                            border: OutlineInputBorder(
                            )
                        ),
                        onChanged: (text) {
                          companyId = text;
                        }
                    )),
                    SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                        ),
                        onPressed: () {
                          if(url.isEmpty || companyId.isEmpty){
                            Get.dialog(
                              MyAlertDialog(
                                content: Globalization.text1.tr, // 对话框内容
                                posiVisible: false,
                              ),
                            );
                            return;
                          }
                          SharedUtils.setString(BASE_URL, url);
                          SharedUtils.setString(COMPANY_ID, companyId);
                          Get.dialog(
                            MyAlertDialog(
                              content: Globalization.success.tr, // 对话框内容
                              posiVisible: true,
                              negaVisible: false,
                            ),
                          );
                        },
                        child: Text(
                          Globalization.confirm.tr,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],)),
          ],
        ),
      ),
    );
  }
}

class FlatButton {
}
