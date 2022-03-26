import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Color? backgroundColor;
  final Color? progressColor;
  final double height;
  final double? width;
  final double? progress;
  final double radius;

  const ProgressBar({
    this.backgroundColor,
    this.progressColor,
    this.height = 8,
    this.width,
    this.progress,
    this.radius = 50,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey.shade300,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: progressColor ?? Colors.green.shade400,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          height: height,
          width: progress,
          // width: _getSpentPercentWidth(context),
        ),
      ],
    );
  }
}
