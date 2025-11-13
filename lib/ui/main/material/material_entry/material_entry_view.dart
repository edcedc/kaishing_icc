import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';
import '../../../../base/pageWidget/base_stateful_widget.dart';
import '../../../../base/pageWidget/base_stateless_widget.dart';
import '../../../../bean/DataBean.dart';
import '../../../../event/event_item_upload.dart';
import '../../../../res/colors.dart';
import '../../../../res/language/Messages.dart';
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

  Widget buildContent(BuildContext context) {
    return Obx(() => Stack(
      children: [
        RefreshWidget<MaterialEntryLogic>(
          controllerTag: tag,
          enablePullUp: false,
          refreshController: controller.refreshController,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () {
                  logic.isLongPressed.value = true;
                  Get.put(EventBus()).fire(EventItemUpload(isLongPressed: true));
                },
                child: ItemMaterialWidgets(
                  itemData: logic.listBean[index],
                  index: index,
                  onTapCallback: () {
                    logic.showDialogMaterialEntry(context, index, logic.listBean[index]);
                  },
                  onItemTapCallback: () {
                    logic.showDialogMaterialEntry(context, index, logic.listBean[index]);
                  },
                ),
              );
            },
            itemCount: logic.listBean.length,
          ),
        ),
        Visibility(
            visible: logic.isLongPressed.value,
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(children: [
                SizedBox(width: 5),
                Expanded(child: ElevatedButton(
                    onPressed: (){
                      Get.put(EventBus()).fire(EventItemUpload(isLongPressed: true, isAll: true));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.color_system,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(Globalization.all.tr))
                ),
                SizedBox(width: 5),
                Expanded(child: ElevatedButton(
                    onPressed: (){
                      logic.isLongPressed.value = false;
                      Get.put(EventBus()).fire(EventItemUpload(isLongPressed: false, isAll: false));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.color_system,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text(Globalization.cancel.tr))
                ),
                SizedBox(width: 5),
              ],), // 自定义的底部按钮布局
        )),
      ],
    ));
  }

}

