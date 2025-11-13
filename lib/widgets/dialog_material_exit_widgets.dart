import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/ui/main/material/material_exit/material_exit_logic.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';

import '../bean/DataBean.dart';
import '../event/event_item_address.dart';
import '../res/language/Messages.dart';

/**
 *  出仓数量填写
 */
class DialogMaterialExitWidgets extends StatefulWidget {

  final int pageType;

  final int index;

  final DataBean itemData;

  final List<DataBean>? listLocationBean;

  DialogMaterialExitWidgets(
    this.pageType,
    this.index,
    this.itemData,
    this.listLocationBean,
  );

  @override
  _DialogMaterialExitWidgets createState() => _DialogMaterialExitWidgets();
}

class _DialogMaterialExitWidgets extends State<DialogMaterialExitWidgets> {

  final logic = Get.put(MaterialExitLogic());

  late int quantity;
  late int quantity2;
  late int selectedIndex;
  late String orderNumber;
  late String locName;
  late String loctionRoNo;
  late int loctionNum;
  late String remarks;

  @override
  void initState() {
    super.initState();
    quantity = widget.itemData.quantity;
    quantity2 = widget.itemData.quantity2;
    orderNumber = logic.orderno.value;
    loctionNum = widget.itemData.loctionNum ;
    locName = widget.itemData.locName ?? '';
    loctionRoNo = widget.itemData.loctionRoNo ?? '';
    remarks = widget.itemData.remarks ?? '';
    widget.itemData.type = widget.pageType;

    /*if(widget.listLocationBean.length != 0){
      var indexWhere = widget.listLocationBean.indexWhere((bean) => bean.loctionRoNo == loctionRoNo);
      selectedIndex = indexWhere == -1 ? 0 : indexWhere;
      locName = widget.listLocationBean[selectedIndex].loctionName!!;
      loctionRoNo = widget.listLocationBean[selectedIndex].loctionRoNo!!;
      loctionNum = widget.listLocationBean[selectedIndex].loctionNum;
    }else{
      if(widget.listLocationBean.indexWhere((bean) => bean.loctionRoNo == '10086') == -1){
        widget.listLocationBean.insert(0, DataBean(loctionName: '一', loctionRoNo: '10086'));
      }
    }*/

    Get.put(EventBus()).on<EventItemAddress>().listen((event) {
      if (mounted) {
        setState(() {
          locName = event.loctionName;
          loctionRoNo = event.loctionRoNo;
          loctionNum = event.loctionNum;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Text(Globalization.outbound_quantity.tr),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: TextEditingController(
                text: quantity == 0 ? '' : '${quantity}',
              ),
              autofillHints: [AutofillHints.name],
              decoration: InputDecoration(
                hintText: quantity == 0 ? '0' : '',
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                if (text.isNotEmpty) {
                  quantity = int.parse(text);
                } else {
                  quantity = 0;
                }
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(Globalization.confirm_outbound_quantity.tr),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: TextEditingController(
                text: quantity2 == 0 ? '' : "${quantity2}",
              ),
              autofillHints: [AutofillHints.name],
              decoration: InputDecoration(
                hintText: quantity2 == 0 ? '0' : '',
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (text) {
                // 确保输入的内容是有效的数字
                if (text.isNotEmpty) {
                  quantity2 = int.parse(text);
                } else {
                  quantity2 = 0; // 如果输入为空，设置为默认值 0
                }
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(Globalization.exit_location.tr),
                Text('*', style: TextStyle(color: Colors.red)),
              ],
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                UIHelper.startItemAddressPage(widget.itemData);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.grey),
                ),
                alignment: Alignment.center,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '${locName}(${loctionNum})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87, // 正常状态文字颜色
                ),
              ),
            ),
            /*Container(
              child: SizedBox(
                width: double.maxFinite,
                height: 40.0,
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  iconSize: 20,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 5, right: 5),
                    border: OutlineInputBorder(gapPadding: 1),
                  ),
                  value: selectedIndex,
                  onChanged: (int? index) {
                    if (index != null) {
                      locName = widget.listLocationBean[index].loctionName!!;
                      loctionRoNo = widget.listLocationBean[index].loctionRoNo!!;
                      loctionNum = widget.listLocationBean[index].loctionNum;
                    }
                  },
                  items: widget.listLocationBean.asMap().entries.map((entry) {
                    int index = entry.key;
                    DataBean bean = entry.value;
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Center(
                        child: Text(loctionRoNo == '10086' ? '${bean.locationName}' : '${bean.loctionName}(${bean.loctionNum})', style: TextStyle(fontSize: 15)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),*/
            SizedBox(height: 10),
            Text(Globalization.project_order_number.tr),
            SizedBox(height: 10),
            TextField(
                controller: TextEditingController(text: orderNumber),
                autofillHints: [AutofillHints.name],
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  orderNumber = text;
                }),
            SizedBox(height: 10),
            Text(Globalization.remarks.tr),
            SizedBox(height: 10),
            TextField(
                controller: TextEditingController(text: remarks),
                minLines: 3,
                maxLines: null,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.text,
                onChanged: (text) {
                  remarks = text;
                }),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
              ),
              onPressed: () {
                if (quantity == 0 || loctionRoNo == '10086') {
                  Fluttertoast.showToast(msg: Globalization.missing_required_fields.tr);
                  return;
                }
                if(quantity != quantity2){
                  Fluttertoast.showToast(msg: Globalization.text4.tr);
                  return;
                }
                // int? result = extractIntFromParentheses(locName);
                if(quantity > loctionNum){
                  Fluttertoast.showToast(msg: Globalization.text4.tr);
                  return;
                }
                final updatedItem = widget.itemData
                  ..quantity = quantity
                  ..quantity2 = quantity2
                  ..orderNumber = orderNumber
                  ..locName = locName
                  ..loctionRoNo = loctionRoNo
                  ..remarks = remarks
                  ..isEdit = true;
                logic.orderno.value = orderNumber;
                // Fluttertoast.showToast(msg: Globalization.success.tr);
                UIHelper.closePage();
                logic.listBean[widget.index] = updatedItem;
              },
              child: Text(Globalization.confirm.tr, style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      )
    );
  }

  int? extractIntFromParentheses(String input) {
    // 使用正则表达式匹配括号内的内容
    RegExp regex = RegExp(r'\((.*?)\)');
    Match? match = regex.firstMatch(input);

    if (match != null && match.groupCount >= 1) {
      // 获取括号内的内容
      String content = match.group(1) ?? '';
      // 尝试将内容转换为整数
      return int.tryParse(content);
    }
    return 0;
  }
}
