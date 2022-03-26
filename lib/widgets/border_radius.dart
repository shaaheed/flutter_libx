import 'package:flutter/material.dart';

class BorderRadiusWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final Color? color;

  const BorderRadiusWidget({
    required this.child,
    this.margin,
    this.borderRadius,
    this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ??
          const EdgeInsets.only(
            bottom: 10.0,
            left: 8.0,
            right: 8.0,
          ),
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(15, 0, 0, 0)),
        color: color,
      ),
      child: child,
    );
  }
}
