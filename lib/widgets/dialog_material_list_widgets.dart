import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyyc/ext/get_extension.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../api/UIHelper.dart';
import '../bean/DataBean.dart';
import '../res/language/Messages.dart';
import 'hig_hlight_text.dart';
import 'item/item_material_widgets.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef OnSaveCallback = void Function(List<DataBean> filteredList);

class DialogMaterialListWidgets extends StatefulWidget {

  final int pageType;
  final List<DataBean> listBean;
  final OnSaveCallback onSave;

  DialogMaterialListWidgets(this.pageType, this.listBean, {required this.onSave});

  @override
  _DialogMaterialListWidgetsState createState() => _DialogMaterialListWidgetsState();
}

class _DialogMaterialListWidgetsState extends State<DialogMaterialListWidgets> {
  final TextEditingController _controller = TextEditingController();
  List<DataBean> _filteredBeans = [];

  @override
  void initState() {
    super.initState();
    _filteredBeans = widget.listBean;
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _controller.text.toLowerCase(); // 将搜索内容转换为小写
    setState(() {
      if (text.isEmpty) {
        _filteredBeans = widget.listBean;
      } else {
        _filteredBeans = widget.listBean.where((item) =>
        (item.materialNo?.toLowerCase()?.contains(text) ?? false) || // 转换为小写后比较
            (item.materialName?.toLowerCase()?.contains(text) ?? false)).toList(); // 转换为小写后比较
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                  onChanged: (text) {
                    // 动态搜索逻辑在 _onSearchChanged 中处理
                  },
                ),
              ),
              Visibility(
                visible: false,
                child: IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: () {
                    Get.back(); // 关闭 BottomSheet
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final item = _filteredBeans[index];
                return Material(
                  color: item.isSave ? Colors.grey[300] : Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        item.isSave = !item.isSave;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HighlightText(
                            text: item.materialNo ?? 'N/A',
                            highlight: _controller.text,
                            defaultStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          HighlightText(
                            text: item.materialName ?? 'N/A',
                            highlight: _controller.text,
                            defaultStyle: TextStyle(color: Colors.black87, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Container(height: 1, color: Colors.grey[700]);
              },
              itemCount: _filteredBeans.length,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.maxFinite,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                    ),
                    onPressed: () {
                      List<DataBean> filteredList = widget.listBean.where((item) => item.isSave).toList();
                      widget.onSave(filteredList); // 调用回调函数，传递 filteredList
                      Get.back();
                    },
                    child: Text(Globalization.confirm.tr, style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
