
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../api/UIHelper.dart';
import '../../../../base/pageWidget/base_stateless_widget.dart';
import '../../../../bean/DataBean.dart';
import '../../../../event/event_item_address.dart';
import '../../../../res/colors.dart';
import '../../../../widgets/load_state_widget.dart';
import '../../../../widgets/zking_widget.dart';
import 'item_address_logic.dart';

class ItemAddressPage extends BaseStatelessWidget<ItemAddressLogic> {
  ItemAddressPage({Key? key}) : super(key: key);

  final logic = Get.put(ItemAddressLogic());
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  @override
  Widget? titleWidget() {
    final Map arguments = Get.arguments;
    final DataBean bean = arguments['bean'];
    return titleView(bean.materialNo!);
  }

  @override
  bool showBackButton() {
    return true;
  }


  @override
  Widget buildContent(BuildContext context) {
    return Container(
      color: ColorStyle.color_F5F5F5,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: '',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      _searchQuery.value = value;
                      if (value.isNotEmpty) {
                        for (var item in logic.listBean) {
                          bool hasMatchInSelf = item.loctionName?.toLowerCase().contains(value.toLowerCase()) ?? false;
                          bool hasMatchInChildren = item.list?.any((subItem) =>
                          subItem.loctionName?.toLowerCase().contains(value.toLowerCase()) ?? false) ?? false;
                          item.isExpanded = hasMatchInSelf || hasMatchInChildren;
                        }
                      } else {
                        for (var item in logic.listBean) {
                          item.isExpanded = false;
                        }
                      }
                      logic.listBean.refresh();
                    },
                  ),
                ),
                SizedBox(width: 8.0),
                Material(
                  color: Colors.transparent, // 设置背景透明
                  child: InkWell(
                    onTap: () {
                      _showZkingDialog(context);
                    },
                    borderRadius: BorderRadius.circular(50), // 可选：设置圆角
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.qr_code_scanner, color: ColorStyle.color_system),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: CupertinoScrollbar(
              radius: Radius.circular(20),
              child: SingleChildScrollView(
                child: Obx(() {
                  final filteredLocations = _filterLocations(logic.listBean, _searchQuery.value);
                  return ExpansionPanelList(
                    expansionCallback: (int index, bool isExpanded) {
                      filteredLocations[index].isExpanded = !isExpanded;
                      logic.listBean.refresh();
                    },
                    children: filteredLocations.map<ExpansionPanel>((DataBean item) {
                      return ExpansionPanel(
                        canTapOnHeader: true,
                        isExpanded: item.isExpanded,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            onTap: () {
                              item.isExpanded = !item.isExpanded;
                              logic.listBean.refresh();
                            },
                            title: Row(
                              children: [
                                Image.asset(
                                  'drawable/images/icon_2.png',
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 8), _buildHighlightText('${item.loctionName}(${item.allLoctionNum})', _searchQuery.value),
                              ],
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            if (item.list != null)
                              ...item.list!.where((subItem) =>
                              _searchQuery.value.isEmpty ||
                                  subItem.loctionName!.toLowerCase().contains(_searchQuery.value.toLowerCase()))
                                  .map((subItem) => InkWell(
                                onTap: () {
                                  Get.put(EventBus()).fire(EventItemAddress(
                                      loctionName: subItem.loctionName!,
                                      loctionRoNo: subItem.loctionRoNo!,
                                      loctionNum: subItem.loctionNum
                                  ));
                                  UIHelper.closePage();
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Row(
                                    children: [
                                      Icon(Icons.place, size: 20, color: ColorStyle.color_89A3F0),
                                      SizedBox(width: 8),
                                      _buildHighlightText('${subItem.loctionName}(${subItem.loctionNum})', _searchQuery.value ),
                                    ],
                                  ),
                                ),
                              )),
                          ],
                        ),
                      );
                    }).toList(),
                    animationDuration: Duration(milliseconds: 200),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showZkingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: ZkingWidget(onCodeDetected: (String code) {
            _searchController.text = code;
            _searchQuery.value = code;
            if (code.isNotEmpty) {
              for (var item in logic.listBean) {
                bool hasMatchInSelf = item.loctionName?.toLowerCase().contains(code.toLowerCase()) ?? false;
                bool hasMatchInChildren = item.list?.any((subItem) =>
                subItem.loctionName?.toLowerCase().contains(code.toLowerCase()) ?? false) ?? false;
                item.isExpanded = hasMatchInSelf || hasMatchInChildren;
              }
            } else {
              for (var item in logic.listBean) {
                item.isExpanded = false;
              }
            }
            logic.listBean.refresh();
            UIHelper.closePage();
          }),
        );
      },
    );
    /*Get.dialog(
      Dialog(
        child: ZkingWidget(onCodeDetected: (String code) {
          _searchController.text = code;
          _searchQuery.value = code;
          UIHelper.closePage();
        }),
      ),
      barrierDismissible: true,
    );*/
  }

  Widget _buildHighlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Expanded(
        child: Text(text, style: TextStyle(fontSize: 15), softWrap: true),
      );
    }

    final matches = <TextSpan>[];
    final textLower = text.toLowerCase();
    final queryLower = query.toLowerCase();
    int start = 0;
    int index;

    while ((index = textLower.indexOf(queryLower, start)) != -1) {
      // 添加非匹配部分
      if (index > start) {
        matches.add(TextSpan(
          text: text.substring(start, index),
          style: TextStyle(color: Colors.black, fontSize: 15),
        ));
      }
      // 添加匹配部分
      matches.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15),
      ));
      start = index + query.length;
    }
    // 添加剩余部分
    if (start < text.length) {
      matches.add(TextSpan(
        text: text.substring(start),
        style: TextStyle(color: Colors.black, fontSize: 15),
      ));
    }

    return Expanded(child: RichText(text: TextSpan(children: matches), overflow: TextOverflow.visible, softWrap: true));
  }

  List<DataBean> _filterLocations(List<DataBean> allLocations, String query) {
    if (query.isEmpty) return allLocations;

    final queryLower = query.toLowerCase();
    return allLocations.where((location) {
      if (location.loctionName?.toLowerCase().contains(queryLower) ?? false) {
        return true;
      }
      if (location.list?.any((subLocation) =>
      subLocation.loctionName?.toLowerCase().contains(queryLower) ?? false) ?? false) {
        return true;
      }
      return false;
    }).toList();
  }

}
