import 'package:flutter/material.dart';
import 'package:fyyc/bean/DataBean.dart';
import 'package:get/get.dart';

import '../../../../base/pageWidget/base_stateless_widget.dart';
import '../../../../widgets/item/item_material_widgets.dart';
import '../../../../widgets/load_state_widget.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import 'material_details_logic.dart';

class MaterialDetailsPage extends BaseStatelessWidget<MaterialDetailsLogic> {
  MaterialDetailsPage({Key? key}) : super(key: key);

  final logic = Get.put(MaterialDetailsLogic());

  @override
  Widget? titleWidget() {
    final Map arguments = Get.arguments;
    final DataBean bean = arguments['bean'];
    return titleView('动态标题 - ');
  }

  @override
  bool showBackButton() {
    return true;
  }

  @override
  Widget buildContent(BuildContext context) {
    final Map arguments = Get.arguments;
    final int index = arguments['index'];
    final DataBean bean = arguments['bean'];
    var listBean = <DataBean>[];
    listBean.add(bean);
    return Container(
      padding: EdgeInsets.all(10),
      width: double.maxFinite,
      color: Colors.grey[200],
      child: ListView(
        children: [
          ItemMaterialWidgets(
            itemData: listBean[index],
            index: index,
            onTapCallback: () {
              // 处理点击事件
              print('Item $index tapped');
            },
          ),
        ],
      ),
    );
  }
}
