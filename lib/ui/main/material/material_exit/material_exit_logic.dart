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
import '../../../../bean/BaseResponseBean.dart';
import '../../../../bean/DataBean.dart';
import '../../../../event/event_item_upload.dart';
import '../../../../event/event_main.dart';
import '../../../../ext/Ext.dart';
import '../../../../res/language/Messages.dart';
import '../../../../utlis/SharedUtils.dart';
import '../../../../utlis/base64_utils.dart';
import '../../../../widgets/dialog/dialog_alert.dart';
import '../../../../widgets/dialog_file_widget.dart';
import '../../../../widgets/dialog_material_entry_widgets.dart';
import '../../../../widgets/dialog_material_exit_widgets.dart';
import '../../../../widgets/dialog_material_list_widgets.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import '../../../../widgets/zking_widget.dart';
import '../../main_logic.dart';
import '../material_entry/material_entry_logic.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;

class MaterialExitLogic extends BaseRefreshController<ApiService> {


  RxList<DataBean> listBean = <DataBean>[].obs;
  //底部弹窗选中物料列表和回调
  RxList<DataBean> listMaterialBean = <DataBean>[].obs;
  List<DataBean> listMaterialCallbackBean = [];
  //item位置选择编辑
  List<DataBean> listLocationBean = [];

  final mainLogic = Get.put(MainLogic());

  var pageType = 1;

  var zkingCode = ''.obs;

  Rx<String> orderno = ''.obs;

  RxBool isLongPressed = false.obs;

  //出仓材料回调
  List<File> listFile = [];

  @override
  void onReady() {
    super.onReady();
    loadNet();
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
          case 3:
            _showDeleteItem();
            break;
          default:
            _upload();
            break;
        }
      }
    });
    Get.put(EventBus()).on<EventItemUpload>().listen((event) {
      if(!event.isLongPressed){
        this.isLongPressed.value = event.isLongPressed;
      }
    });
  }

  void _showDeleteItem() {
    List<DataBean> list = listBean.where((bean) => bean.isDelete).toList();
    if (list.length != 0) {
      Get.dialog(
        MyAlertDialog(
          title: Globalization.appName.tr,
          content: Globalization.delete1.tr,
          posiVisible: true,
          posiTap: () {
            listBean.removeWhere((bean) => bean.isDelete == true);
            final remainingIds = listBean.map((bean) => bean.id).toSet();
            for (final material in listMaterialBean) {
              material.isSave = remainingIds.contains(material.id);
            }
            uploadStatus();
            if(listBean.length == 0){
              Get.put(EventBus()).fire(EventItemUpload(isLongPressed: false, isAll: false));
            }
          },
        ),
      );
    }
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
            uploadStatus();
          }
        }),
      ),
      barrierDismissible: true,
    );
  }

  void _showCustomDialog() {
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
          pageType,
          listMaterialBean,
          onSave: (filteredList) {
            final Set<int> allowedIds = filteredList.map((e) => e.id!).toSet();
            listBean.removeWhere((bean) => !allowedIds.contains(bean.id));
            final Set<int> existingIds = listBean.map((e) => e.id!).toSet();
            listBean.addAll(
              filteredList.where((bean) => !existingIds.contains(bean.id)),
            );
            uploadStatus();
          },
        ),
      ),
    );
  }

  @override
  void loadNet() {
    requestPageData();
  }

  void uploadStatus(){
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
    httpRequest<List<DataBean>>(api.getMaterialList(pageType, bean.userid, bean.companyID), (value) {
      if (refresh == Refresh.first || refresh == Refresh.pull) {
        listMaterialBean.clear();
      }
      for (DataBean bean in value) {
        if (bean.pic is List<DataBean>) {
          List<DataBean> picList = bean.pic as List<DataBean>;
          bean.pic = picList.where((picc) => picc.image?.isNotEmpty ?? false).toList();
        }
      }
      final roNoMap = {for (var bean in listBean) bean.roNo: bean};
      value.forEach((materialBean) {
        if (roNoMap.containsKey(materialBean.roNo)) {
          materialBean.isSave = roNoMap[materialBean.roNo]!.isSave;
        }
      });
      listMaterialBean.addAll(value);

      final materialBeanMap = {for (var bean in listMaterialBean) bean.roNo: bean};
      for (var bean in listBean) {
        if (materialBeanMap.containsKey(bean.roNo)) {
          final matchingBean = materialBeanMap[bean.roNo]!;
          bean.materialName = matchingBean.materialName;
          bean.purposeName = matchingBean.purposeName;
          bean.inventoryLimit = matchingBean.inventoryLimit;
          bean.inventoryNum = matchingBean.inventoryNum;
          bean.pic = matchingBean.pic;
        }
      }
      listBean.refresh();
      uploadStatus();
      hideRefresh(refreshController, finishLoadMore: true);
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
          posiTap: () {
            _apiCreateMaterialInbound(list);
          },
        ),
      );
    }
  }

  void _apiGetMaterialList() {
    Get.showLoading();
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getMaterialList(pageType, bean.userid, bean.companyID), (value) {
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
    _showItemEdidDialog(context, index, bean.loc);
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

  void _showItemEdidDialog(BuildContext context, int index, List<DataBean>? locBean){
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.7,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: DialogMaterialExitWidgets(pageType, index, listBean[index], locBean),
      ),
    );
  }

  Future<void> _apiCreateMaterialInbound(List<DataBean> list) async {
    Get.showLoading();
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
    // var base64 = await Base64Utils().convertFilesToBase64(listFile);
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    Map<String, dynamic> map = {};
    map["userid"] = bean.userid;
    map["companyID"] = bean.companyID;
    map["jsonData"] = json.encode(jsonArray);
    map["orderno"] = orderno.value;
    for (int i = 0; i < listFile.length; i++) {
      File file = listFile[i];
      map["file$i"] = [
        await dio.MultipartFile.fromFile(file.path, filename: path.basename(file.path))
      ];
    }
    dio.FormData formData = dio.FormData.fromMap(map);

    httpRequest<BaseResponseBean>(api.CreateMaterialOutbound(formData), (value) {
      Get.dismiss();
      if(value.code == 200){
        Get.dialog(
          MyAlertDialog(
            content: Globalization.success.tr,
            negaVisible: false,
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
            bean.inventoryNum -= num;
            bean.loctionNum -= num;
            /*if (bean.loc != null) {
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
            }*/
          }
        }

        /*for (DataBean bean in listMaterialBean) {
          bean.inventoryNum = bean.loc?.fold(0, (sum, element) => sum! + element.loctionNum) ?? 0;
        }*/

        uploadStatus();
      }else{

      }
    }, showLoading: false);
  }

}