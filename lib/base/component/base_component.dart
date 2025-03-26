import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/load_state_widget.dart';
import '../../widgets/loading_widget.dart';
import '../controller/base_controller.dart';

///定义View组件--页面内某个模块cheng
abstract class BaseComponent<T extends BaseController> extends GetView<T> {
  String? componentTag;

  BaseComponent({Key? key, this.componentTag}) : super(key: key);

  @override
  String? get tag => componentTag;

  @override
  Widget build(BuildContext context) {
    return controller.obx((state) => buildContent(context),
        onLoading: Center(
          child: LoadingWidget(),
        ),
        onError: (error) => createErroWidget(controller, error),
        onEmpty: createEmptyWidget(controller));
  }

  ///showSuccess展示成功的布局
  Widget buildContent(BuildContext context);
}
