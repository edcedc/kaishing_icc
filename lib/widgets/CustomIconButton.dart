import 'package:flutter/material.dart';

//图标按钮点击事件
class CustomIconButton extends StatelessWidget {

  final IconData iconData; // 图标
  final double size; // 图标大小
  final Color color; // 图标颜色
  final VoidCallback onTap; // 点击事件回调

  const CustomIconButton({
    Key? key,
    required this.iconData,
    this.size = 40.0,
    this.color = Colors.black45,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // 设置 Material 背景为透明
      child: InkWell(
        onTap: onTap, // 点击事件
        borderRadius: BorderRadius.circular(20), // 设置水波纹的圆角
        child: Padding(
          padding: const EdgeInsets.all(8.0), // 增加内边距以扩大点击区域
          child: Icon(iconData, size: size, color: color),
        ),
      ),
    );
  }
}