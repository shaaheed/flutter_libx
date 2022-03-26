import 'package:flutter/material.dart';

class RowTrailingWidget extends StatelessWidget {
  final String? trailing;
  final bool selected;

  const RowTrailingWidget(
    this.trailing, {
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (selected)
          const Icon(
            Icons.done,
            color: Color(0xFF2196F3),
          ),
        if (trailing != null)
          Text(
            trailing as String,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
