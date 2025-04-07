import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  final String text;
  final String highlight;
  final TextStyle defaultStyle; // 默认样式参数

  HighlightText({
    required this.text,
    required this.highlight,
    this.defaultStyle = const TextStyle(fontSize: 12), // 默认样式
  });

  @override
  Widget build(BuildContext context) {
    if (highlight.isEmpty) {
      return Text(text, style: defaultStyle); // 如果没有高亮内容，直接返回默认样式
    }

    List<InlineSpan> spans = [];
    int lastPos = 0;

    // 查找匹配的文本并高亮显示
    while (true) {
      int index = text.toLowerCase().indexOf(highlight.toLowerCase(), lastPos);
      if (index == -1) {
        // 添加剩余部分
        spans.add(TextSpan(text: text.substring(lastPos), style: defaultStyle));
        break;
      }
      if (index > lastPos) {
        // 添加非匹配部分
        spans.add(TextSpan(text: text.substring(lastPos, index), style: defaultStyle));
      }
      // 添加匹配部分，应用高亮样式
      spans.add(TextSpan(
        text: text.substring(index, index + highlight.length),
        style: defaultStyle.copyWith(color: Colors.red), // 只改变颜色，保持其他样式不变
      ));
      lastPos = index + highlight.length;
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}