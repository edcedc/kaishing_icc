import 'package:get/get.dart';

import '../../../../api/api_service.dart';
import '../../../../base/controller/base_refresh_controller.dart';
import '../../../../bean/DataBean.dart';

class MaterialDetailsLogic extends BaseRefreshController<ApiService> {

  @override
  void onReady() {
    showSuccess();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onHidden() { }
}
