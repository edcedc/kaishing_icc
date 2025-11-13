import 'dart:convert';

import 'package:get/get.dart';
import '../../../../api/api_service.dart';
import '../../../../base/controller/base_refresh_controller.dart';
import '../../../../bean/DataBean.dart';
import '../../../../ext/Ext.dart';
import '../../../../utlis/SharedUtils.dart';
import '../../../../widgets/pull_smart_refresher.dart';

class ItemAddressLogic extends BaseRefreshController<ApiService> {

  RxList<DataBean> listBean = <DataBean>[].obs;

  late String mrono;
  late String batchno;
  late int type;

  @override
  void onReady() {
    super.onReady();
    final Map arguments = Get.arguments;
    final DataBean bean = arguments['bean'];
    mrono = bean.roNo!;
    batchno = bean.batchNo!;
    type = bean.type!;
    requestPageData();
  }

  @override
  void requestPageData({Refresh refresh = Refresh.first}) {
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getLocationMaterial(bean.userid, bean.companyID, mrono, batchno, type), (value) {
      if (refresh == Refresh.first || refresh == Refresh.pull) {
        listBean.clear();
      }
      if (value != null && value.isNotEmpty) {
        listBean.assignAll(value.where((item) => item.loctionLevel == 0));
        if(type == 0){
          for (DataBean bean in listBean) {
            var subLocations = value.where((item) => item.locTopRoNo == bean.locTopRoNo).toList();
            int totalNum = subLocations.fold(0, (sum, item) => sum + (item.loctionNum ?? 0));
            bean.allLoctionNum = totalNum;
            bean.list = subLocations;
          }
        }else{
          List<DataBean> list = <DataBean>[];
          for (DataBean bean in listBean) {
            var subLocations = value.where((item) => item.locTopRoNo == bean.locTopRoNo && item.loctionNum != 0).toList();
            int totalNum = subLocations.fold(0, (sum, item) => sum + (item.loctionNum ?? 0));
            bean.allLoctionNum = totalNum;
            bean.list = subLocations;
            if(bean.allLoctionNum > 0){
              list.add(bean);
            }
          }
          listBean.clear();
          listBean.addAll(list);
        }
        showSuccess();
      }else{
        showEmpty();
      }
      hideRefresh(refreshController, finishLoadMore: true);
    }, handleError: true, handleSuccess: false);
  }

  @override
  void onHidden() {
  }

  @override
  void onClose() {
    super.onClose();
  }

}

