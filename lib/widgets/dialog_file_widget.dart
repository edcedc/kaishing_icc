import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart' as p;

import '../res/language/Messages.dart';

typedef OnSaveCallback = void Function(List<File> filteredList);

/**
 *  添加资料
 */
class DialogFileWidget extends StatefulWidget {

  final List<File>? initialFiles;

  final OnSaveCallback onSave;

  DialogFileWidget(this.initialFiles, {required this.onSave});

  _DialogFileWidget createState() => _DialogFileWidget();

}

class _DialogFileWidget extends State<DialogFileWidget> {

  List<File> _files = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialFiles != null) {
      _files = widget.initialFiles!.toList();
    }
  }

  /*拍照*/
  _photo() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera, // 指定从相机拍摄
      imageQuality: 20, // 可选参数，图片质量（0-100）
      preferredCameraDevice: CameraDevice.rear, // 可选参数，指定前后摄像头
    );
    if (image != null) {
      _files.add(File(image.path));
      print(image.path);
    }
    setState(() {});
  }

  Future<void> _addItem() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'png'],
    );
    if (result != null) {
      List<String?> paths = result.paths;
      for (String? path in paths) {
        if (path != null) {
          _files.add(File(path));
          print(path);
        }
      }
      setState(() {});
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(child:
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 每行显示 2 个元素
              crossAxisSpacing: 10, // 横向间距
              mainAxisSpacing: 10, // 纵向间距
              childAspectRatio: 1, // 子元素的宽高比（宽度 / 高度）
            ),
            itemCount: _files.length,
            itemBuilder: (context, index) {
              String filePath = _files[index].path;
              String fileName = p.basename(filePath); // 获取文件名
              String fileExtension = p.extension(filePath).toLowerCase(); // 获取文件扩展名
              Widget fileIcon;

              switch (fileExtension) {
                case '.jpg':
                case '.png':
                case '.jpeg':
                  fileIcon = Image.file(
                    File(filePath),
                    fit: BoxFit.cover,
                  );
                  break;
                case '.pdf':
                  fileIcon = Image.asset('drawable/images/icon_1.jpeg');
                  break;
                case '.txt':
                  fileIcon = Icon(Icons.text_fields);
                  break;
                default:
                  fileIcon = Icon(Icons.insert_drive_file);
              }
              return Card(
                elevation: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    fileIcon, // 背景图片或其他内容
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                          fileName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                    // 删除图标，放置在右上角
                    Positioned(
                      top: 5, // 距离顶部的间距
                      right: 5, // 距离右侧的间距
                      child: GestureDetector(
                        onTap: () {
                          // 删除当前 item 的逻辑
                          setState(() {
                            _files.removeAt(index); // 假设 _files 是你的数据列表
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // 图标的背景颜色
                          ),
                          child: Icon(
                            Icons.delete,
                            size: 24,
                            color: Colors.red, // 图标的颜色
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
          SizedBox(height: 10),
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
                      _photo();
                    },
                    child: Text('${Globalization.photo.tr}', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                    ),
                    onPressed: () {
                      _addItem();
                    },
                    child: Text('${Globalization.local_file.tr}', style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                    ),
                    onPressed: () {
                      if(_files.length > 3){
                        Fluttertoast.showToast(msg: Globalization.text5.tr);
                        return;
                      }
                      widget.onSave(_files);
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

