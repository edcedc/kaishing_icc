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
import '../ui/main/material/material_entry/material_entry_logic.dart';
import '../utlis/language/Messages.dart';
import '../utlis/mixin/toast/toast_mixin.dart';

/**
 *  入仓数量填写
 */
class DialogMaterialEntryWidgets extends StatelessWidget {

  final int pageType;

  final int index;

  final DataBean itemData;

  final List<DataBean> listLocationBean;

  final logic = Get.put(MaterialEntryLogic());

  DialogMaterialEntryWidgets(
    this.pageType,
    this.index,
    this.itemData,
    this.listLocationBean,
  );

  @override
  Widget build(BuildContext context) {
    int quantity = itemData.quantity;
    int selectedIndex = 0;
    double price = itemData.price;
    String orderNumber = '';
    String locName = itemData.locName ?? '';
    String loctionRoNo = itemData.loctionRoNo ?? '';
    int loctionNum = itemData.loctionNum;
    String remarks = itemData.remarks ?? '';

    if(listLocationBean.length != 0){
      var indexWhere = listLocationBean.indexWhere((bean) => bean.loctionRoNo == loctionRoNo);
      selectedIndex = indexWhere == -1 ? 0 : indexWhere;
      locName = listLocationBean[selectedIndex].loctionName!!;
      loctionRoNo = listLocationBean[selectedIndex].loctionRoNo!!;
      loctionNum = listLocationBean[selectedIndex].loctionNum;
    }else{
      if(listLocationBean.indexWhere((bean) => bean.loctionRoNo == '10086') == -1){
        listLocationBean.insert(0, DataBean(loctionName: '一', loctionRoNo: '10086'));
      }
    }
    return Container(
      padding: EdgeInsets.all(20),
      child: ListView(
        children: [
          Row(
            children: [
              Text(Globalization.quantity.tr),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            controller: TextEditingController(
              text: itemData.quantity == 0 ? '' : itemData.quantity.toString(),
            ),
            autofillHints: [AutofillHints.name],
            decoration: InputDecoration(
              hintText: itemData.quantity == 0 ? '0' : '',
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
          Text(Globalization.unit_price.tr),
          SizedBox(height: 10),
          TextField(
            controller: TextEditingController(
              text: itemData.price == 0 ? '' : itemData.price.toStringAsFixed(1),
            ),
            autofillHints: [AutofillHints.name],
            decoration: InputDecoration(
              hintText: itemData.price == 0 ? '0.0' : '',
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
            ],
            onChanged: (text) {
              // 将输入的字符串转换为 double
              if (text.isNotEmpty) {
                double? parsedValue = double.tryParse(text);
                if (parsedValue != null) {
                  itemData.price = parsedValue;
                }
              } else {
                itemData.price = 0;
              }
            },
          ),
          SizedBox(height: 10),
          Text(Globalization.order_number.tr),
          SizedBox(height: 10),
          TextField(
              controller: TextEditingController(text: logic.orderno.value),
              autofillHints: [AutofillHints.name],
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  border: OutlineInputBorder()),
              keyboardType: TextInputType.text,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9]*$')),
              ],
              onChanged: (text) {
                orderNumber = text;
              }),
          SizedBox(height: 10),
          Row(
            children: [
              Text(Globalization.entry_location.tr),
              Text('*', style: TextStyle(color: Colors.red)),
            ],
          ),
          SizedBox(height: 10),
          Container(
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
                    locName = listLocationBean[index].loctionName!!;
                    loctionRoNo = listLocationBean[index].loctionRoNo!!;
                    loctionNum = listLocationBean[index].loctionNum;
                  }
                },
                items: listLocationBean.asMap().entries.map((entry) {
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
          ),
          SizedBox(height: 10),
          Text(Globalization.remarks.tr),
          SizedBox(height: 10),
          TextField(
              controller: TextEditingController(text: itemData.remarks),
              minLines: 3,
              maxLines: null,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                  border: OutlineInputBorder()),
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
              itemData.quantity = quantity;
              itemData.price = price;
              itemData.orderNumber = orderNumber;
              logic.orderno.value = orderNumber;
              itemData.locName = locName;
              itemData.loctionRoNo = loctionRoNo;
              itemData.remarks = remarks;
              itemData.isEdit = true;
              // Fluttertoast.showToast(msg: Globalization.success.tr);
              logic.listBean[index] = itemData;
              UIHelper.closePage();
            },
            child: Text(Globalization.confirm.tr, style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
