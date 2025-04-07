import 'dart:convert';
import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/event/event_main.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import '../../../../api/api_service.dart';
import '../../../../base/controller/base_refresh_controller.dart';
import '../../../../bean/BaseResponseBean.dart';
import '../../../../bean/DataBean.dart';
import '../../../../ext/Ext.dart';
import '../../../../utlis/SharedUtils.dart';
import '../../../../utlis/base64_utils.dart';
import '../../../../utlis/language/Messages.dart';
import '../../../../widgets/dialog/dialog_alert.dart';
import '../../../../widgets/dialog_file_widget.dart';
import '../../../../widgets/dialog_material_entry_widgets.dart';
import '../../../../widgets/dialog_material_list_widgets.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import '../../../../widgets/zking_widget.dart';
import '../../main_logic.dart';
import '../material_exit/material_exit_logic.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart' as path;

class MaterialEntryLogic extends BaseRefreshController<ApiService> {

  RxList<DataBean> listBean = <DataBean>[].obs;
  //底部弹窗选中物料列表和回调
  RxList<DataBean> listMaterialBean = <DataBean>[].obs;
  List<DataBean> listMaterialCallbackBean = [];
  //item位置选择编辑
  List<DataBean> listLocationBean = [];

  final mainLogic = Get.put(MainLogic());

  var pageType = 0.obs;

  Rx<String> orderno = ''.obs;

  //入仓材料回调
  List<File> listFile = [];

  @override
  void onReady() {
    super.onReady();
    loadNet();
    requestPageData();
    Get.put(EventBus()).on<EventMain>().listen((event) {
      if (event.type == 0) {
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
    mainLogic.apptitle.value = Globalization.material_entry.tr + '(${listBean.length})';
  }

  @override
  void requestPageData({Refresh refresh = Refresh.first}) {
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getMaterialList(0, bean.userid, bean.companyID), (value) {
      // if (refresh == Refresh.first || refresh == Refresh.pull) {
      //   listMaterialBean.clear();
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
          posiTap: () {
            // _apiCreateMaterialInbound(list);
            _apiCreateMaterialInbound2(list);
            // _apiCreateMaterialInbound3(list);
          },
        ),
      );
    }
  }

  void _apiGetMaterialList() {
    Get.showLoading();
    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<List<DataBean>>(api.getMaterialList(0, bean.userid, bean.companyID), (value) {
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
    LogUtils.e("onClose");
  }

  @override
  void onHidden() {
    LogUtils.e("onHidden");
  }

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
        child: DialogMaterialEntryWidgets(pageType.value, index, listBean[index], locBean),
      ),
    );
  }

  Future<void> _apiCreateMaterialInbound3(List<DataBean> list) async {
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
        'Supplier': bean.supplier,
      };
      jsonArray.add(jsonObject);
    }
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

    dio.Dio dioInstance = dio.Dio();
    // 发起请求并监听上传进度
    try {
      dio.Response response = await dioInstance.post(
        "${SharedUtils.getString(BASE_URL)}/MobileWebService.asmx/createMaterialInbound", // 替换为实际的上传接口地址
        data: formData,
        onSendProgress: (int sent, int total) {
          double progress = sent / total;
          Get.showLoading(text: "${(progress * 100).toStringAsFixed(0)}%");
          print("上传进度：${(progress * 100).toStringAsFixed(0)}%");
        },
      );
      print(response.data);
      Get.dismiss();
    } on dio.DioError catch (e) {
      print("上传失败：${e.message}");
      Get.dismiss();
    }
  }


  Future<void> _apiCreateMaterialInbound2(List<DataBean> list) async {
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
        'Supplier': bean.supplier,
      };
      jsonArray.add(jsonObject);
    }
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

   /* List<dio.MultipartFile> fileList = [];
    for (int i = 0; i < listFile.length; i++) {
      File file = listFile[i];
      fileList.add(await dio.MultipartFile.fromFile(
        file.path,
        filename: path.basename(file.path),
      ));
    }
    map["file"] = fileList;*/

    dio.FormData formData = dio.FormData.fromMap(map);

    httpRequest<BaseResponseBean>(api.CreateMaterialInbound(formData), (value) {
      Get.dismiss();
      if(value.code == 200){
        Get.dialog(
          MyAlertDialog(
            content: Globalization.success.tr,
            negaVisible: false,
          ),
        );
        final materialExitLogic = Get.put(MaterialExitLogic());

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
              DataBean? matchingBean = bean.loc!.firstWhereOrNull((dataBean) => dataBean.loctionRoNo == locationRoNo);
              if (matchingBean != null) {
                matchingBean.loctionNum = matchingBean.loctionNum + num;

                DataBean? exitItemBean = materialExitLogic.listMaterialBean!.firstWhereOrNull((dataBean) => dataBean.materialNo == materialNo);
                if(exitItemBean != null){
                  var loc = exitItemBean.loc;
                  DataBean? locBean = loc!.firstWhereOrNull((dataBean) => dataBean.loctionRoNo == locationRoNo);
                  if(locBean != null){
                    locBean.loctionNum = locBean.loctionNum + num;
                  }else{
                    var bean = DataBean();
                    bean.loctionRoNo = locationRoNo;
                    bean.loctionName = matchingBean.loctionName;
                    bean.loctionNum = num;
                    loc.add(bean);
                  }
                }

              }
            }
          }
        }

        for (DataBean bean in listMaterialBean) {
          bean.inventoryNum = bean.loc?.fold(0, (sum, element) => sum! + element.loctionNum) ?? 0;
        }

        loadNet();
      }else{

      }
    }, showLoading: false);
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
        'Supplier': bean.supplier,
      };
      jsonArray.add(jsonObject);
    }
    Get.showLoading();

    /*String base64 = '';
    if(listFile.length != 0){
      // 创建一个 ReceivePort 用于接收 Isolate 的返回值
      ReceivePort receivePort = ReceivePort();
      // 创建 Isolate 并执行 Base64 转换
      Isolate.spawn(_convertFilesToBase64, receivePort.sendPort);
      // 等待 Isolate 的返回值
      base64 = await receivePort.first;
      // 关闭 ReceivePort
      receivePort.close();
    }*/

    var base64 = await Base64Utils().convertFilesToBase64(listFile);

    DataBean bean = DataBean.fromJson(json.decode(SharedUtils.getString(USER_DATA)));
    httpRequest<DataBean>(api.createMaterialInbound(bean.userid, bean.companyID, json.encode(jsonArray), base64, orderno.value), (value) {
      Get.dismiss();
      if(value.code == 200){
        Get.dialog(
          MyAlertDialog(
            content: Globalization.success.tr,
            negaVisible: false,
          ),
        );
        final materialExitLogic = Get.put(MaterialExitLogic());

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
              DataBean? matchingBean = bean.loc!.firstWhereOrNull((dataBean) => dataBean.loctionRoNo == locationRoNo);
              if (matchingBean != null) {
                matchingBean.loctionNum = matchingBean.loctionNum + num;

                DataBean? exitItemBean = materialExitLogic.listMaterialBean!.firstWhereOrNull((dataBean) => dataBean.materialNo == materialNo);
                if(exitItemBean != null){
                  var loc = exitItemBean.loc;
                  DataBean? locBean = loc!.firstWhereOrNull((dataBean) => dataBean.loctionRoNo == locationRoNo);
                  if(locBean != null){
                    locBean.loctionNum = locBean.loctionNum + num;
                  }else{
                    var bean = DataBean();
                    bean.loctionRoNo = locationRoNo;
                    bean.loctionName = matchingBean.loctionName;
                    bean.loctionNum = num;
                    loc.add(bean);
                  }
                }

              }
            }
          }
        }

        for (DataBean bean in listMaterialBean) {
          bean.inventoryNum = bean.loc?.fold(0, (sum, element) => sum! + element.loctionNum) ?? 0;
        }

        loadNet();
      }else{

      }
    }, showLoading: false);
  }

}

