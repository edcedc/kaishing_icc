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
import '../ui/main/material/item_address/item_address_logic.dart';
import '../ui/main/material/material_entry/material_entry_logic.dart';
import '../utlis/mixin/toast/toast_mixin.dart';
import 'dialog/dialog_alert.dart';

/**
 *  入仓数量填写
 */
class DialogMaterialEntryWidgets extends StatefulWidget {

  final int pageType;

  final int index;

  final DataBean itemData;

  final List<DataBean>? listLocationBean;

  DialogMaterialEntryWidgets(
      this.pageType,
      this.index,
      this.itemData,
      this.listLocationBean,);

  @override
  _DialogMaterialEntryWidgets createState() => _DialogMaterialEntryWidgets();
}

class _DialogMaterialEntryWidgets extends State<DialogMaterialEntryWidgets> {

  final logic = Get.put(MaterialEntryLogic());

  late List<DataBean> locList;
  late int quantity;
  late double price;
  late String orderNumber;
  late String locName;
  late String loctionRoNo;
  late int loctionNum;
  late String remarks;
  late String supplier;
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    quantity = widget.itemData.quantity;
    price = widget.itemData.price;
    orderNumber = logic.orderno.value;
    loctionRoNo = widget.itemData.loctionRoNo ?? '';
    loctionNum = widget.itemData.loctionNum;
    locName = widget.itemData.locName ?? '';
    remarks = widget.itemData.remarks ?? '';
    supplier = widget.itemData.supplier ?? '';
    widget.itemData.type = widget.pageType;

    var loc = widget.itemData.loc;
    if(loc != null && loc.length != 0){
      locList = loc.where((item) => item.loctionLevel == 0).toList();
      for(DataBean bean in locList){
        var list = loc?.where((item) => item.locTopRoNo == bean.locTopRoNo).toList();
        bean.list = list;
      }
    }

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
                  Text(Globalization.quantity.tr),
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
              Text(Globalization.unit_price.tr),
              SizedBox(height: 10),
              TextField(
                controller: TextEditingController(
                  text: price == 0 ? '' : price.toStringAsFixed(1),
                ),
                autofillHints: [AutofillHints.name],
                decoration: InputDecoration(
                  hintText: price == 0 ? '0.0' : '',
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
                      price = parsedValue;
                    }
                  } else {
                    price = 0;
                  }
                },
              ),
              SizedBox(height: 10),
              Text(Globalization.order_number.tr),
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
              Row(
                children: [
                  Text(Globalization.entry_location.tr),
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
                child: ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      isExpanded = !isExpanded;
                      locList[index].isExpanded = !isExpanded;
                      LogUtils.e("${locList[index].toString()}");
                    });
                  },
                  children: locList.map<ExpansionPanel>((DataBean item) {
                    return ExpansionPanel(
                      canTapOnHeader: true,
                      isExpanded: item.isExpanded,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(item.loctionName!),
                        );
                      },
                      body: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: (){
                              LogUtils.e(item.list![index].toString());
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              child: Text(item.list![index].loctionName!),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Container(height: 1.0, color: Color(0xfff2f2f2));
                        },
                        itemCount: item.list!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                    );
                  }).toList(),
                  animationDuration: Duration(microseconds: 100),
                ),
              ),
              Container(
                child: SizedBox(
                  width: double.maxFinite,
                  height: 40.0,
                  child: DropdownButtonFormField<int>(
                    menuMaxHeight: 300,
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
              Text(Globalization.proveedores.tr),
              SizedBox(height: 10),
              TextField(
                  controller: TextEditingController(text: supplier),
                  autofillHints: [AutofillHints.name],
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                      border: OutlineInputBorder()),
                  keyboardType: TextInputType.text,
                  onChanged: (text) {
                    supplier = text;
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
                  final updatedItem = widget.itemData
                    ..quantity = quantity
                    ..price = price
                    ..orderNumber = orderNumber
                    ..locName = locName
                    ..loctionRoNo = loctionRoNo
                    ..remarks = remarks
                    ..supplier = supplier
                    ..isEdit = true;
                  logic.orderno.value = orderNumber;
                  // Fluttertoast.showToast(msg: Globalization.success.tr);
                  logic.listBean[widget.index] = updatedItem;
                  UIHelper.closePage();
                },
                child: Text(Globalization.confirm.tr, style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        )
    );
  }
}

