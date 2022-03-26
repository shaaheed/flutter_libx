import 'package:flutter/material.dart';
import '/utils.dart';

class AppBarAction extends StatelessWidget {
  final String? image;
  final Text? text;
  final Icon? icon;
  final void Function()? onTap;

  const AppBarAction({
    this.image,
    this.text,
    this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          if (image != null) Utils.image(image, height: 37) as Image,
          if (image == null && text != null) text as Widget,
          if (icon != null) icon as Widget,
          // Icon(
          //   Icons.arrow_drop_down,
          //   color: Colors.black.withOpacity(0.4),
          // ),
        ],
      ),
      onTap: onTap,
    );
  }
}
