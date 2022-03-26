import 'package:flutter/material.dart';
import '/utils.dart';

class AppIconButton extends StatelessWidget {
  final Color? color;
  final double size;
  final IconData? icon;
  final Image? image;
  final String? imageName;
  final double height;
  final double width;
  final AlignmentGeometry? alignment;
  final VoidCallback? onTap;
  final bool noIcon;

  final _AppIconButtonData data = _AppIconButtonData();

  AppIconButton({
    this.color,
    this.size = 40.0,
    this.icon,
    this.image,
    this.imageName,
    this.height = 50.0,
    this.width = 60.0,
    this.alignment,
    this.onTap,
    this.noIcon = false,
    Key? key,
  }) : super(key: key) {
    if (!noIcon) {
      if (image != null) {
        data.icon = image as Widget;
      } else if (imageName != null) {
        data.icon = Utils.image(imageName);
      } else if (icon != null) {
        data.icon = Icon(
          icon,
          color: color ?? const Color.fromARGB(127, 0, 0, 0),
          size: size,
        );
      } else {
        data.icon = Utils.image(imageName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return data.icon != null
        ? IconButton(
            icon: data.icon as Widget,
            padding: const EdgeInsets.all(0.0),
            onPressed: onTap,
          )
        : SizedBox(width: size + 8);
  }
}

class _AppIconButtonData {
  Widget? icon;
}
