import 'package:flutter/material.dart';
import 'package:fyyc/bean/DataBean.dart';
import 'package:fyyc/res/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

class ImagePage extends StatefulWidget {
  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late PageController _pageController;
  late List<DataBean> images;
  late int initialIndex;
  String title = ''; // 定义一个类级别的变量

  @override
  void initState() {
    super.initState();
    images = Get.arguments['images'] ?? [];
    initialIndex = Get.arguments['index'] ?? 0;
    _pageController = PageController(initialPage: initialIndex);
    title = '${initialIndex + 1}/${images.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: ColorStyle.color_system,
        title: Text(title, style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back(); // 关闭页面
          },
        ),
      ),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          // 使用唯一的 tag，例如结合图片 URL 和索引
          final uniqueTag = "${images[index]}-$index";
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images![index].image!!),
            heroAttributes: PhotoViewHeroAttributes(tag: uniqueTag),
          );
        },
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            title = '${index + 1}/${images.length}';
          });
        },
      ),
    );
  }
}