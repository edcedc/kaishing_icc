import 'package:flutter/material.dart';

/**
 *  登录注册页的输入框
 */
class TextFieldWeight1 extends StatefulWidget {

  const TextFieldWeight1(
      {super.key,
      required this.hihtText,
      required this.prefixIcon,
      required this.showClear, required this.onTextChanged, required this.text});

  final String hihtText;
  final IconData prefixIcon;
  final bool showClear;
  final ValueChanged<String> onTextChanged; // 定义一个回调函数
  final String text;

  @override
  State<TextFieldWeight1> createState() => _TextField1State();
}

class _TextField1State extends State<TextFieldWeight1> {

  late TextEditingController _controller = TextEditingController(text: widget.text);

  bool showPad = false;

  onClear() {
    _controller.clear();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        textInputAction: TextInputAction.done,
        obscureText: widget.showClear ? false : !showPad,
        onChanged: (value) {
          setState(() {
            widget.onTextChanged(value); // 调用回调函数并传递text的值
          });
        },
        controller: _controller,
        style: TextStyle(
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: widget.hihtText,
          labelText: widget.hihtText,
          prefixIcon: Icon(widget.prefixIcon),
          suffixIcon: _controller.text.length > 0
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      if (widget.showClear) {
                        onClear();
                      } else {
                        showPad = !showPad;
                      }
                    });
                  },
                  icon: Icon(widget.showClear
                      ? Icons.clear
                      : (showPad ? Icons.visibility_off : Icons.visibility)))
              : null,
        ),
      ),
    );
  }
}
