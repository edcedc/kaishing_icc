import 'dart:async';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:fyyc/widgets/load_state_widget.dart';
import 'package:get/get.dart';

import '../../base/pageWidget/base_stateless_widget.dart';
import '../../bean/DataBean.dart';
import '../../event/event_item_upload.dart';
import '../../event/event_main.dart';
import '../../ext/Ext.dart';
import '../../res/colors.dart';
import '../../res/language/Messages.dart';
import '../../utlis/SharedUtils.dart';
import '../../widgets/text_icon_button_widget.dart';
import '../text_page.dart';
import 'main_logic.dart';
import 'material/material_entry/material_entry_logic.dart';
import 'material/material_entry/material_entry_view.dart';
import 'material/material_exit/material_exit_logic.dart';
import 'material/material_exit/material_exit_view.dart';

class MainPage extends BaseStatelessWidget<MainLogic> {
  MainPage({Key? key}) : super(key: key);

  final logic = Get.put(MainLogic());
  final materialExitLogic = Get.put(MaterialExitLogic());
  final materialEntryLogic = Get.put(MaterialEntryLogic());

  final EventBus eventBus = Get.put(EventBus());

  @override
  Widget? titleWidget() {
    return Obx(() => titleView(logic.apptitle.value));
  }

  @override
  bool showDrawer() {
    return true;
  }

  @override
  List<Widget>? appBarActionWidget(BuildContext context) {
    return [
      Obx(() => IconButton(onPressed: () {
        if(logic.isLongPressed.value){
          eventBus.fire(EventMain(logic.selectedIndex.value, 3));
        }else{
          eventBus.fire(EventMain(logic.selectedIndex.value, -1));
        }
      }, icon: logic.isLongPressed.value ? Icon(Icons.delete) : Icon(Icons.upload)))
    ];
  }

  List<Widget> tabViewList = [
    MaterialEntryPage(),//入仓
    MaterialExitPage(),//出仓
  ];

  @override
  Widget createDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorStyle.color_system100,
                  ColorStyle.color_system900
                ], // 渐变色从浅红到深红
                begin: Alignment.topCenter, // 渐变开始位置
                end: Alignment.bottomCenter, // 渐变结束位置
              ),
            ),
            child: Container(
              height: 200,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextIconButtonWidget(
                    icon: Icons.link,
                    text: 'www.spit.hk',
                    onPressed: () { },
                  ),
                  SizedBox(height: 10),
                  TextIconButtonWidget(
                    icon: Icons.phone,
                    text: '+852 27558899',
                    onPressed: () { },
                  ),
                  SizedBox(height: 10),
                  TextIconButtonWidget(
                    icon: Icons.public,
                    text: 'Rm205, Block 16W, Hong Kong Science Park',
                    onPressed: () {
                      UIHelper.startLogin();
                    },
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.storage),
            title: Text(Globalization.material_entry.tr),
            onTap: () {
              materialEntryLogic.loadNet();
              logic.selectedIndex.value = 0;
              Navigator.pop(context);
              Get.put(EventBus()).fire(EventItemUpload(isLongPressed: false, isAll: false));
              // materialEntryLogic.isLongPressed.value = false;
              // materialExitLogic.isLongPressed.value = false;
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text(Globalization.material_exit.tr),
            onTap: () {
              materialExitLogic.loadNet();
              logic.selectedIndex.value = 1;
              Navigator.pop(context);
              Get.put(EventBus()).fire(EventItemUpload(isLongPressed: false, isAll: false));
              // materialExitLogic.isLongPressed.value = false;
              // materialEntryLogic.isLongPressed.value = false;
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(Globalization.sign_out.tr),
            onTap: () {
              DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
              bean.password = null;
              SharedUtils.setString(USER_DATA, json.encode(bean));
              UIHelper.startLogin();
            },
          )
        ],
      ),
    );
  }

  // 点击网站地址的逻辑
  void _launchWebsite() async {
    const url = 'https://www.example.com';
  }

  // 点击电话的逻辑
  void _launchPhone() async {
    const phoneNumber = 'tel:+1234567890';
  }

  @override
  Widget buildContent(BuildContext context) {
    return Scaffold(
      body: Obx(() => tabViewList[logic.selectedIndex.value]),
      floatingActionButton: Obx(() => Visibility(
        visible: !logic.isLongPressed.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                eventBus.fire(EventMain(logic.selectedIndex.value, 1));
              },
              mini: false,
              elevation: 2,
              backgroundColor: ColorStyle.color_system,
              child: Transform.scale(
                scale: 1.6,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                eventBus.fire(EventMain(logic.selectedIndex.value, 0));
              },
              mini: false,
              elevation: 2,
              backgroundColor: ColorStyle.color_system,
              child: Transform.scale(
                scale: 1.6,
                child: Icon(Icons.link, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () {
                eventBus.fire(EventMain(logic.selectedIndex.value, 2));
              },
              mini: false,
              elevation: 2,
              backgroundColor: ColorStyle.color_system,
              child: Transform.scale(
                scale: 1.6,
                child: Icon(Icons.qr_code_scanner, color: Colors.white),
              ),
            ),
          ],
        ),
      )),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

}
