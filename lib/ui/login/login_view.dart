import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:get/get.dart';

import '../../base/pageWidget/base_stateless_widget.dart';
import '../../res/colors.dart';
import '../../res/language/Messages.dart';
import '../../widgets/CustomIconButton.dart';
import '../../widgets/TextFieldWeight1.dart';
import 'login_logic.dart';

class LoginPage extends BaseStatelessWidget<LoginLogic> {
  LoginPage({Key? key}) : super(key: key);

  final logic = Get.put(LoginLogic());

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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: [
            Expanded(child: ListView(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomIconButton(
                    iconData: Icons.settings,
                    size: 40,
                    onTap: () {
                      UIHelper.startSetting();
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
                    Obx(() => TextFieldWeight1(
                      hihtText: Globalization.account.tr,
                      prefixIcon: Icons.supervisor_account_outlined,
                      showClear: true,
                      onTextChanged: (String value) {
                        logic.account.value = value;
                      },
                      text: logic.account.value,
                    )),
                    Obx(() => TextFieldWeight1(
                      hihtText: Globalization.password.tr,
                      prefixIcon: Icons.key,
                      showClear: false,
                      onTextChanged: (String value) {
                        logic.pwd.value = value;
                      },
                      text: logic.pwd.value,
                    )),
                    SizedBox(height: 20),
                    Container(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                        ),
                        onPressed: () {
                          logic.onlogin();
                        },
                        child: Text(
                          Globalization.login.tr,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],)),
            Center(child: Obx(() => Text('${logic.version.value}')),),
          ],
        ),
      ),
    );
  }
}
