import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fyyc/utlis/mixin/log/LogUtils.dart';
import 'package:get/get.dart';

import '../../api/UIHelper.dart';
import '../../bean/DataBean.dart';
import '../../event/event_item_upload.dart';
import '../../res/language/Messages.dart';
import '../../ui/main/main_logic.dart';
import '../../ui/main/material/material_entry/material_entry_logic.dart';
import '../../ui/main/material/material_exit/material_exit_logic.dart';

class ItemMaterialWidgets extends StatefulWidget {

  final DataBean itemData;
  final int index;
  final VoidCallback? onTapCallback;
  final VoidCallback? onItemTapCallback;
  final VoidCallback? onLongPressCallback;

  const ItemMaterialWidgets({
    Key? key,
    required this.itemData,
    required this.index,
    this.onItemTapCallback,
    this.onTapCallback,
    this.onLongPressCallback,
  }) : super(key: key);

  @override
  State<ItemMaterialWidgets> createState() => _ItemMaterialWidgetsState();
}

class _ItemMaterialWidgetsState extends State<ItemMaterialWidgets> {

  bool isLongPressed = false;

  bool isALL = false;

  @override
  void initState() {
    super.initState();
    Get.put(EventBus()).on<EventItemUpload>().listen((event) {
      setState(() {
        this.isLongPressed = event.isLongPressed;
        // if(!this.isLongPressed){
        //   widget.itemData.isDelete = false;
        // }

        this.isALL = event.isAll;
        widget.itemData.isDelete = this.isALL;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onLongPress: () {
        setState(() => isLongPressed = true);
        widget.onLongPressCallback?.call();
      },*/
      onTap: () {
        if(isLongPressed){
          setState(() {
            widget.itemData.isDelete = !widget.itemData.isDelete;
          });
        }else{
          widget.onItemTapCallback?.call();
        }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.w),
          child: Row(
            children: [
              Visibility(
                visible: isLongPressed,
                child: _buildImagePickerButton(),
              ),
              Expanded(child: _createContent()
            )
          ],),
        ),
      ),
    );
  }

  // 图片选择按钮组件
  Widget _buildImagePickerButton() {
    return Icon(
      widget.itemData.isDelete ? Icons.check_box : Icons.check_box_outline_blank,
      color: widget.itemData.isDelete ? Colors.blue : Colors.grey,
    );
  }

  Widget _createContent() {
    var pic = widget.itemData.pic;
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
                Text(widget.itemData.materialNo ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.material_name.tr + "："),
                    Expanded(child: AutoSizeText(widget.itemData.materialName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.usage.tr + "："),
                    Expanded(child: AutoSizeText(widget.itemData.purposeName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.location.tr + "："),
                    Expanded(child: AutoSizeText(widget.itemData.locName ?? "", maxLines: 2)),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.minimum_stock.tr + "："),
                    Expanded(child: AutoSizeText('${widget.itemData.inventoryLimit}')),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Globalization.current_stock.tr + "："),
                    Expanded(child: AutoSizeText('${widget.itemData.inventoryNum}')),
                  ],
                ),
                Visibility(
                  visible: widget.itemData.validityDate != null && widget.itemData.validityDate != "",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Globalization.expiration_date.tr + "："),
                      Expanded(child: AutoSizeText('${widget.itemData.validityDate}')),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
            // onTap: widget.onTapCallback,
            child: Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.add_box_outlined,
                color: widget.itemData.isEdit ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}