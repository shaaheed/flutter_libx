import 'package:flutter/material.dart';
import '/widgets/positioned_image.dart';
import '/widgets/progress_bar.dart';

class TitleProgress extends StatelessWidget {
  final String? titleLeftText;
  final String? titleRightText;
  final TextStyle? titleTextStyle;
  final EdgeInsets titlePadding;
  final String? subtitleLeftText;
  final String? subtitleRightText;
  final TextStyle? subtitleTextStyle;
  final EdgeInsets subtitlePadding;
  final EdgeInsets progressPadding;
  final ProgressBar? progress;
  final String? image;

  const TitleProgress({
    this.titleLeftText,
    this.titleRightText,
    this.titleTextStyle,
    this.titlePadding = const EdgeInsets.only(top: 10),
    this.subtitleLeftText,
    this.subtitleRightText,
    this.subtitleTextStyle,
    this.subtitlePadding = const EdgeInsets.only(top: 3),
    this.progress,
    this.progressPadding = const EdgeInsets.only(top: 3),
    this.image,
    Key? key,
  }) : super(key: key);

  TextStyle get defaultTitleTextStyle => TextStyle(
        color: Colors.grey.shade600,
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (image != null)
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: PositionedImage(image: image as String),
          ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: titlePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      titleLeftText ?? "",
                      style: titleTextStyle ?? defaultTitleTextStyle,
                    ),
                    Text(
                      titleRightText ?? "",
                      style: titleTextStyle ?? defaultTitleTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: subtitlePadding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subtitleLeftText ?? "", style: subtitleTextStyle),
                    Text(subtitleRightText ?? "", style: subtitleTextStyle),
                  ],
                ),
              ),
              Padding(padding: progressPadding, child: progress),
            ],
          ),
        )
      ],
    );
  }
}
