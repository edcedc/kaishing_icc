import 'package:fyyc/ext/Ext.dart';
import 'package:fyyc/utlis/SharedUtils.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';

import '../../api/api_service.dart';
import '../../base/controller/base_refresh_controller.dart';

class SettingLogic extends BaseRefreshController<ApiService> {

  var url = ''.obs;
  var company_id = ''.obs;

  @override
  void onReady() {
    super.onReady();
    showSuccess();
    url.value = SharedUtils.getString(BASE_URL)!;
    company_id.value = SharedUtils.getString(COMPANY_ID)!;
  }

  @override
  void onResumed() {
    super.onResumed();
    LogUtils.e(url.toString());
    LogUtils.e(company_id.toString());
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onHidden() {

  }

}
