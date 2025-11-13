import 'package:flutter/material.dart';


class TextPage extends StatelessWidget {
  const TextPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Sticky Headers'),
      ),
      body: ListView(
        children: <Widget>[
          _Item(
            text: 'List Example',
          ),
          _Item(
            text: 'Grid Example',
          ),
          _Item(
            text: 'Not Sticky Example',
          ),
          _Item(
            text: 'Side Header Example',
          ),
          _Item(
            text: 'Animated Header Example',
          ),
          _Item(
            text: 'Reverse List Example',
          ),
          _Item(
            text: 'Mixing other slivers',
          ),
          _Item(
            text: 'Nested sticky headers',
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {



  const _Item({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;
  @override
  Widget build(BuildContext context) {
    final List<String> items = List.generate(15, (index) => "Item ${index + 1}");

    return Card(
      color: Colors.blue,
      child: InkWell(
        onTap: () =>
            {},
        child: Container(
          padding: EdgeInsets.all(16),
          child:  ListView.builder(
          itemCount: items.length, // 数据总数
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index], // 使用数据生成文本
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              // 可选：添加背景颜色或其他样式
              tileColor: Colors.blue,
            );
          },
        ),
        ),
      ),
    );
  }
}