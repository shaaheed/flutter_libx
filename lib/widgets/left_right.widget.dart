import 'package:flutter/material.dart';

class LeftRightWidget extends StatelessWidget {
  final List<Widget> left;
  final List<Widget>? right;

  const LeftRightWidget({
    required this.left,
    this.right,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: left,
          ),
        ),
        if (right != null && right!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: right as List<Widget>,
          )
      ],
    );
  }
}
