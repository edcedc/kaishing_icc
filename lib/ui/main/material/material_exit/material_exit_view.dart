import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../base/pageWidget/base_stateful_widget.dart';
import '../../../../base/pageWidget/base_stateless_widget.dart';
import '../../../../widgets/dialog_material_entry_widgets.dart';
import '../../../../widgets/item/item_material_widgets.dart';
import '../../../../widgets/pull_smart_refresher.dart';
import '../material_entry/material_entry_logic.dart';
import 'material_exit_logic.dart';
/**
 *  物料出仓
 */
class MaterialExitPage extends BaseStatelessWidget<MaterialExitLogic> {
  MaterialExitPage({Key? key}) : super(key: key);

  final logic = Get.put(MaterialExitLogic());

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
