import 'dart:convert';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/event/event_main.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';

import '../../../../api/api_service.dart';
import '../../../../base/controller/base_refresh_controller.dart';
import '../../../../bean/DataBean.dart';
import '../../../../event/event_main.dart';
import '../../../../ext/Ext.dart';
import '../../../../utlis/SharedUtils.dart';
import '../../../../utlis/base64_utils.dart';
import '../../../../utlis/language/Messages.dart';
import '../../../../widgets/dialog/dialog_alert.dart';
import '../../../../widgets/dialog_file_widget.dart';
import '../../../../widgets/dialog_material_entry_widgets.dart';
import '../../../../widgets/dialog_material_exit_widgets.dart';
import '../../../../widgets/dialog_material_list_widgets.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import '../../../../widgets/zking_widget.dart';
import '../../main_logic.dart';
import '../material_entry/material_entry_logic.dart';


class MaterialExitLogic extends BaseRefreshController<ApiService> {


  RxList<DataBean> listBean = <DataBean>[].obs;
  //底部弹窗选中物料列表和回调
  RxList<DataBean> listMaterialBean = <DataBean>[].obs;
  List<DataBean> listMaterialCallbackBean = [];
  //item位置选择编辑
  List<DataBean> listLocationBean = [];

  final mainLogic = Get.put(MainLogic());

  var pageType = 1.obs;

  var zkingCode = ''.obs;

  Rx<String> orderno = ''.obs;

  //出仓材料回调
  List<File> listFile = [];

  @override
  void onReady() {
    super.onReady();
    loadNet();
    requestPageData();
    Get.put(EventBus()).on<EventMain>().listen((event) {
      if (event.type == 1) {
        switch (event.tapType) {
          case 0:
            _showFile();
            break;
          case 1:
            if (listMaterialBean.length != 0) {
              _showCustomDialog();
            } else {
              _apiGetMaterialList();
            }
            break;
          case 2:
            _showZkingDialog();
            break;
          default:
            _upload();
            break;
        }
      }
    });
  }

  void _showFile() {
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.5,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DialogFileWidget(
          listFile,
          onSave: (List<File> filteredList) {
            listFile.clear();
            listFile.addAll(filteredList);
          },
        ),
      ),
    );
  }

  void _showZkingDialog() {
    Get.dialog(
      Dialog(
        child: ZkingWidget(onCodeDetected: (String code) {
          Get.back();
          DataBean? bean = listBean.firstWhereOrNull((bean) => bean.materialNo == code);
          if(bean != null){
            return;
          }
          DataBean? materialBean = listMaterialBean.firstWhereOrNull((bean) => bean.materialNo == code);
          if(materialBean != null){
            listBean.add(materialBean);
            materialBean.isSave = true;
            loadNet();
          }
        }),
      ),
      barrierDismissible: true,
    );
  }

  void _showCustomDialog() {
    /*Map<String, DataBean> materialMap = {
      for (var item in listMaterialBean) item.RoNo!: item..isSave = false,
    };
    for (var callbackItem in listMaterialCallbackBean) {
      materialMap[callbackItem.RoNo]?.isSave = true;
    }
    final uniqueListMaterialBean = materialMap.values.toList();*/
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.7,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DialogMaterialListWidgets(
          pageType.value,
          listMaterialBean,
          onSave: (filteredList) {
            // listMaterialCallbackBean.clear();
            // listMaterialCallbackBean.addAll(filteredList);

            Set<int> filteredRoNoSet = filteredList.map((bean) => bean.id!).toSet();
            listBean.removeWhere((bean) => !filteredRoNoSet.contains(bean.id));

            for (var bean in filteredList) {
              if (!listBean.any((item) => item.id == bean.id)) {
                listBean.add(bean);
              }
            }
            loadNet();
          },
        ),
      ),
    );
  }

  @override
  void loadNet() {
    if(listBean.length != 0){
      showSuccess();
    }else{
      showEmpty();
    }
    mainLogic.apptitle.value = Globalization.material_exit.tr + '(${listBean.length})';
  }

  @override
  void requestPageData({Refresh refresh = Refresh.first}) {
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getMaterialList(1, bean.loginID, bean.companyID), (value) {
      // if (refresh == Refresh.first || refresh == Refresh.pull) {
      //   listBean.clear();
      // }
      for (DataBean bean in value) {
        if (bean.pic is List<DataBean>) {
          List<DataBean> picList = bean.pic as List<DataBean>;
          bean.pic = picList.where((picc) => picc.image?.isNotEmpty ?? false).toList();
        }
      }
      listMaterialBean.addAll(value);
      // hideRefresh(refreshController, finishLoadMore: true);
    }, handleError: true, handleSuccess: false);
  }

  void _upload() {
    List<DataBean> list = listBean.where((bean) => bean.isEdit).toList();
    if (list.length != 0) {
      var sb = new StringBuffer();
      for (int i = 0; i < list.length; i++) {
        sb.write(list[i].materialNo);
        if (i < list.length - 1) {
          sb.write(',');
        }
      }
      Get.dialog(
        MyAlertDialog(
          title: Globalization.upload1.tr,
          content: sb.toString(),
          posiVisible: true,
          negaTap: () {
            _apiCreateMaterialInbound(list);
          },
        ),
      );
    }
  }

  void _apiGetMaterialList() {
    Get.showLoading();
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getMaterialList(1, bean.loginID, bean.companyID), (value) {
      Get.dismiss();
      if (refresh == Refresh.first || refresh == Refresh.pull) {
        listMaterialBean.clear();
      }
      for (DataBean bean in value) {
        if (bean.pic is List<DataBean>) {
          List<DataBean> picList = bean.pic as List<DataBean>;
          bean.pic = picList.where((picc) => picc.image?.isNotEmpty ?? false).toList();
        }
      }
      listMaterialBean.addAll(value);
      _showCustomDialog();
    }, showLoading: false);
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onHidden() {}

  void showDialogMaterialEntry(context, index, DataBean bean) {
    // if(listLocationBean.length != 0){
    //   _showItemEdidDialog(context, index);
    // }else{
    //   _apigetLocationMaterial(context, index);
    // }
    _showItemEdidDialog(context, index, bean.loc!);
  }

  void _apigetLocationMaterial(BuildContext context, int index) {
    Get.showLoading();
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    // httpRequest<List<DataBean>>(api.getLocationMaterial(bean.loginID, bean.companyID), (value) {
    //   Get.dismiss();
    //   listLocationBean.addAll(value);
    //   _showItemEdidDialog(context, index);
    // }, showLoading: false);
  }

  void _showItemEdidDialog(BuildContext context, int index, List<DataBean> locBean){
    Get.bottomSheet(
      Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DialogMaterialExitWidgets(pageType.value, index, listBean[index], locBean),
      ),
    );
  }

  Future<void> _apiCreateMaterialInbound(List<DataBean> list) async {
    List<Map<String, dynamic>> jsonArray = [];
    for (DataBean bean in list) {
      Map<String, dynamic> jsonObject = {
        'ID': bean.id,
        'MRoNo': bean.roNo,
        'BatchNo': bean.batchNo,
        'Num': bean.quantity,
        'Price': bean.price,
        'OrderNo': bean.orderNumber,
        'Location': bean.loctionRoNo,
        'Remarks': bean.remarks,
        'MaterialNo': bean.materialNo,
      };
      jsonArray.add(jsonObject);
    }
    var base64 = 'await Base64Utils().convertFilesToBase64(listFile)';
    Get.showLoading();
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<DataBean>(api.createMaterialOutbound(bean.userid, bean.companyID, json.encode(jsonArray), base64, orderno.value), (value) {
      Get.dismiss();
      if(value.code == 200){
        Get.dialog(
          MyAlertDialog(
            content: Globalization.success.tr,
            posiVisible: false,
          ),
        );
        final materialEntryLogic = Get.put(MaterialEntryLogic());

        for (var jsonObject in jsonArray) {
          int id = jsonObject['ID'];
          listBean.removeWhere((bean) => bean.id == id);
          int num = jsonObject['Num'];
          String locationRoNo = jsonObject['Location'];
          String materialNo = jsonObject['MaterialNo'];
          for (var bean in listMaterialBean.where((bean) => bean.id == id)) {
            bean.isSave = false;
            bean.isEdit = false;
            if (bean.loc != null) {
              DataBean matchingBean = bean.loc!.firstWhere((dataBean) => dataBean.loctionRoNo == locationRoNo);
              if (matchingBean != null) {
                matchingBean.loctionNum = matchingBean.loctionNum - num;
              }

              DataBean? itemBean = materialEntryLogic.listMaterialBean!.firstWhereOrNull((dataBean) => dataBean.materialNo == materialNo);
              if(itemBean != null){
                DataBean? locBean = itemBean.loc!.firstWhereOrNull((dataBean) => dataBean.loctionRoNo == locationRoNo);
                if(locBean != null){
                  locBean.loctionNum = locBean.loctionNum - num;
                }
              }

            }
          }
        }
        for (DataBean bean in listMaterialBean) {
          var loc = bean.loc;
          if (loc != null) {
            int totalLoctionNum = loc.fold(0, (sum, element) => sum + element.loctionNum);
            bean.inventoryNum = totalLoctionNum;
          }
        }
        loadNet();
      }else{

      }
    }, showLoading: false);
  }

}