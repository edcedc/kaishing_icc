import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/bean/DataBean.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';

import '../../bean/BaseResponseBean.dart';
import '../../ext/Ext.dart';
import '../../http/app_except.dart';
import '../../http/result/base_result.dart';
import '../../http/result/base_wan_result.dart';
import '../../res/language/Messages.dart';
import '../../utlis/mixin/toast/toast_mixin.dart';

///具有状态控制和网络请求能力的controller，等价MVVM中的ViewModel
abstract class BaseController<M> extends SuperController with ToastMixin {
  late M api;
  late EventBus eventBus;
  List<StreamSubscription>? _stremSubList;
  RxString barTitleString = "标题".obs;

  @override
  void onInit() {
    super.onInit();
    LogUtils.e('>>>>>>>onInit');
  }

  void loadNet();

  /// 发起网络请求，同时处理异常，loading
  httpRequest<T>(Future<T> future, FutureOr<dynamic> Function(T value) onValue,
      { Function(Exception e)? error,
      bool showLoading = false,
      bool handleError = false,
      bool handleSuccess = true}) {
    if (showLoading) {
      Get.showLoading();
    }
    future.then((t) {
      ///添加结果码判断（同时考虑加入List的判断逻辑）
      if (t is BaseResponseBean) {
        baseResponseBeanHandler(t, handleSuccess, onValue, handleError);
      } else if(t is List<DataBean>){
        var isfoundBeans = t.any((element) => element.status == '204');
        if(isfoundBeans){
          Get.dismiss();
          UIHelper.startLogin();
          showToast(Globalization.please_login_again.tr);
        }
        if (handleSuccess) {
          showSuccess();
        }
        onValue(t);
      } else{
        if (handleSuccess) {
          showSuccess();
        }
         onValue(t);
      }
    }).catchError((e) {
      LogUtils.e("网络请求异常====>error:$e");
      if (handleError) {
        showError(e: e);
      }
      if (error != null) {
        error(e);
      }
      showToast(e.toString());
      Get.dismiss();
    }).whenComplete(() {
      if (showLoading) {
        Get.dismiss();
      }
    });
  }

  ///多网络请求简单封装
  multiHttpRequest(List<Future<dynamic>> futures,
      FutureOr<dynamic> Function(dynamic value) onValue,
      {Function(Exception e)? error,
      bool showLoading = false,
      bool handleError = true,
      bool handleSuccess = true}) async {
    if (showLoading) {
      Get.showLoading();
    }
    Future.wait(futures).then((value) {
      onValue(value);
    }).catchError((e) {
      LogUtils.e("网络请求异常====>error:$e");
      if (handleError) {
        showError(e: e);
      }
      if (error != null) {
        error(e);
      }
      showToast(e.toString());
    }).whenComplete(() {
      if (showLoading) {
        Get.dismiss();
      }
    });
  }

  @override
  void onDetached() {
    LogUtils.e('>>>>>>>onDetached');
  }

  @override
  void onInactive() {
    LogUtils.e('>>>>>>>onInactive');
  }

  @override
  void onPaused() {
    LogUtils.e('>>>>>>>onPaused');
  }

  @override
  void onResumed() {
    LogUtils.e('>>>>>>>onResumed');
  }

  @override
  void onReady() {
    super.onReady();
    LogUtils.e('>>>>>>>onReady');
    if (useEventBus()) {
      eventBus = Get.find<EventBus>();
    }
    try {
      api = Get.find<M>();
    } catch (e) {
      LogUtils.e(e.toString());
    }
    // loadNet();
  }

  @override
  void onClose() {
    super.onClose();
    //解订阅EventBus
    disposeEventBus();
    LogUtils.e('>>>>>>>onClose');
  }

  ///解订阅StreamSubscription--关联EventBus
  void disposeEventBus() {
    _stremSubList?.forEach((element) {
      element.cancel();
    });
  }

  void showSuccess() {
    change(null, status: RxStatus.success());
  }

  void showEmpty() {
    change(null, status: RxStatus.empty());
  }

  void showError({String? errorMessage, dynamic? e}) {
    if (e != null) {
      if (e is DioError && e.error is AppException) {
        var error = e.error as AppException;
        change(null, status: RxStatus.error(error.message));
      } else {
        change(null, status: RxStatus.error(errorMessage));
      }
    } else {
      change(null, status: RxStatus.error(errorMessage));
    }
  }

  void showLoading() {
    change(null, status: RxStatus.loading());
  }

  ///是否使用GetX查找EventBus
  bool useEventBus() => false;

  ///管理Eventbus解订阅
  void addStremSub(StreamSubscription? streamSubscription) {
    _stremSubList ??= [];
    if (streamSubscription != null) {
      _stremSubList?.add(streamSubscription);
    }
  }

  void baseResponseBeanHandler<T>(t, bool handleSuccess,
      FutureOr<dynamic> Function(T value) onValue, bool handleError) {
    if (t.code == RESULT_CODE_SUCCESS) {
      if (handleSuccess) {
        showSuccess();
      }
      onValue(t);
    }else {
      if (handleError) {
        showToast(t.msg);
        showError(errorMessage: t.msg);
      } else {
        onValue(t);
        if (handleSuccess) {
          showSuccess();
        }
      }
    }
  }
}
