import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../base/controller/base_refresh_controller.dart';
import '../../bean/DataBean.dart';
import '../../event/event_item_upload.dart';
import '../../ext/Ext.dart';
import '../../res/language/Messages.dart';
import '../../utlis/SharedUtils.dart';

class MainLogic extends BaseRefreshController<ApiService> {

  var apptitle = Globalization.material_entry.tr.obs;

  var account = ''.obs;

  var selectedIndex = 0.obs;

  var isLongPressed = false.obs;

  @override
  void onReady() {
    super.onReady();
    showSuccess();
    _initAccountPwd();
    Get.put(EventBus()).on<EventItemUpload>().listen((event) {
      isLongPressed.value = event.isLongPressed;
    });
  }

  void _initAccountPwd(){
    var string = SharedUtils.getString(USER_DATA);
    if(!string.isEmpty){
      DataBean bean = DataBean.fromJson(json.decode(string));
      account.value = bean.loginID!;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onHidden() { }
}
