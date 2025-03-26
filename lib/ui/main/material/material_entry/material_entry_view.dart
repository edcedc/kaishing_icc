import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../base/pageWidget/base_stateful_widget.dart';
import '../../../../base/pageWidget/base_stateless_widget.dart';
import '../../../../bean/DataBean.dart';
import '../../../../widgets/dialog_material_entry_widgets.dart';
import '../../../../widgets/item/item_material_widgets.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import 'material_entry_logic.dart';

/**
 *  物料入仓
 */
class MaterialEntryPage extends BaseStatelessWidget<MaterialEntryLogic> {
  MaterialEntryPage({Key? key}) : super(key: key);

  final logic = Get.put<MaterialEntryLogic>(MaterialEntryLogic());

  @override
  bool showTitleBar() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Obx(() => ListView.builder(
        itemBuilder: (context, index) {
          return ItemMaterialWidgets(
            itemData: logic.listBean[index],
            index: index,
            onTapCallback: () {
              logic.showDialogMaterialEntry(context, index, logic.listBean[index]);
            },
            onItemTapCallback: () {
              logic.showDialogMaterialEntry(context, index, logic.listBean[index]);
            },
          );
        },
        itemCount: logic.listBean.length,
      )),
    );
  }

}

