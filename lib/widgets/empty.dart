import 'package:flutter/material.dart';
import '../widgets/center.dart';

class Empty extends StatelessWidget {
  static final Color _color = Colors.grey.shade600;
  static TextStyle style = TextStyle(color: _color, fontSize: 16);

  // final double _size = 120;
  final List<Widget> text;
  final IconData icon;

  const Empty({
    required this.text,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterWidget(
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          // width: _size,
          // height: _size,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(100)),
          ),
          child: Icon(
            icon,
            size: 70,
            color: Colors.grey[500],
          ),
        ),
        Row(children: text),
        const SizedBox(height: 100)
      ],
    );
  }

  static Widget tapIcon(IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Icon(iconData, size: 24.0, color: _color),
    );
  }

  static Widget textWidget(String text) {
    return Text(text, style: textStyle);
  }

  static TextStyle get textStyle => style;
}
