import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextIconButtonWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  TextIconButtonWidget({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // 设置点击事件
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10), // 添加图标和文本之间的间距
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.visible, // 默认值，内容过长时自动换行
            ),
          ),
        ],
      ),
    );
  }
}
