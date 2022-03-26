import 'package:flutter/material.dart';

class FormRow extends StatelessWidget {
  final List<Widget> left;
  final List<Widget> right;

  const FormRow({
    required this.left,
    this.right = const <Widget>[],
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // color: Colors.red,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: left,
          ),
          if (right.isNotEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: right,
              ),
            ),
        ],
      ),
    );
  }
}
