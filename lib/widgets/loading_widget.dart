import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'frame_animate_widget.dart';

////页面加载Loading动画
class LoadingWidget extends StatelessWidget {
  ///gaplessPlayback属性是解决加载帧动画闪烁，根本原因是图片解析速度跟不上帧动画加载速度，导致刚开始加载闪烁
  var imageCache = {
    0: Image.asset(
      "drawable/images/common_loading.png",
      gaplessPlayback: true,
    ),
  };

  LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return FrameAnimateWidget(imageCache, 200.w, 200.w, Colors.transparent);
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blue, // 设置进度条的颜色
        strokeWidth: 4, // 设置进度条的宽度
      ),
    );
  }
}
