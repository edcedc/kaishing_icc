import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fyyc/api/UIHelper.dart';
import 'package:get/get.dart';
import '../../bean/DataBean.dart';
import '../../utlis/language/Messages.dart';

class ItemMaterialWidgets extends StatelessWidget {

  final DataBean itemData;
  final int index;
  final VoidCallback? onTapCallback;
  final VoidCallback? onItemTapCallback;

  ItemMaterialWidgets({Key? key, required this.itemData, required this.index, this.onItemTapCallback, this.onTapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      color: Colors.white,
      child: InkWell(
        onTap: onItemTapCallback,
        borderRadius: BorderRadius.circular(20.w),
        child: _createContent(),
      ),
    );
  }

  Widget _createContent() {
    var pic = itemData.pic;
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemData.materialNo ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.material_name.tr + "："),
                    Expanded(child: AutoSizeText(itemData.materialName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.usage.tr + "："),
                    Expanded(child: AutoSizeText(itemData.purposeName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(Globalization.location.tr + "："),
                    Expanded(child: AutoSizeText(itemData.locName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.minimum_stock.tr + "："),
                    Expanded(child: AutoSizeText('${itemData.inventoryLimit}')),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.current_stock.tr + "："),
                    Expanded(child: AutoSizeText('${itemData.inventoryNum}')),
                  ],
                ),
                Visibility(
                  visible: itemData.validityDate != null && itemData.validityDate != "",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Globalization.expiration_date.tr + "："),
                      Expanded(child: AutoSizeText('${itemData.validityDate}')),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                GridView.builder(
                  shrinkWrap: true, // 使 GridView 的高度自适应
                  physics: NeverScrollableScrollPhysics(), // 禁止滚动
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemCount: pic?.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        UIHelper.startImage(index, pic);
                      },
                      child: Image.network(
                        pic![index].image!!,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: onTapCallback, // 为 Icon 添加点击事件
            child: Container(
              padding: EdgeInsets.all(5), // 增大点击范围
              child: Icon(Icons.add_box_outlined,  color: itemData.isEdit ? Colors.green : Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
