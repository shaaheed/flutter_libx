import 'package:flutter/material.dart';
import '../widgets.dart';

class IconFormRow extends StatelessWidget {
  final AppIconButton? icon;
  final List<Widget>? right;
  final Widget? child;
  final bool noIcon;

  const IconFormRow({
    this.icon,
    this.child,
    this.right,
    this.noIcon = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormRow(
      left: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: noIcon
                  ? const SizedBox(
                      width: 48,
                    )
                  : icon ?? AppIconButton(),
            ),
          ],
        ),
      ],
      right: [
        if (child != null) child as Widget,
        if (right != null && right!.isNotEmpty) ...?right,
      ],
    );
  }
}
