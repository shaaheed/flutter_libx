import 'package:flutter/material.dart';
import '../positioned_image.dart';
import '../../enums/selected_indicator.dart';
import './row_subtitle.widget.dart';
import './row_trailing.widget.dart';

class ListRowWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? trailing;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final bool selected;
  final String? image;
  final String? positionedImage;
  final SelectedIndicator indicator;
  final bool noIcon;
  final EdgeInsets padding;

  const ListRowWidget({
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.selected = false,
    this.image,
    this.positionedImage,
    this.indicator = SelectedIndicator.none,
    this.noIcon = false,
    this.padding = const EdgeInsets.all(0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: Colors.yellow,
      contentPadding: const EdgeInsets.only(
        left: 4.0,
        right: 15.0,
        top: 3.0,
        bottom: 3.0,
      ),
      onTap: onTap,
      onLongPress: onLongPress,
      title: Row(
        children: <Widget>[
          if ((selected && indicator == SelectedIndicator.none) || !noIcon)
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (selected && indicator == SelectedIndicator.none)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(right: 3),
                        decoration: const BoxDecoration(
                          color: Color(0xFF2196F3),
                          shape: BoxShape.circle,
                        ),
                      )
                    else
                      const SizedBox(width: 11, height: 8),
                    if (!noIcon)
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: PositionedImage(
                          image: image,
                          positionedImage: positionedImage,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          Expanded(
            child: Padding(
              padding: padding,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title ?? "",
                          style: const TextStyle(fontSize: 18.0),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty)
                    RowSubtitleWidget(subtitle as String),
                ],
              ),
            ),
          ),
          RowTrailingWidget(
            trailing,
            selected: selected && indicator == SelectedIndicator.rightTick,
          ),
          // SizedBox(
          //   // color: Colors.yellow,
          //   child: Row(
          //     children: [
          //       if (selected && indicator == SelectedIndicator.RightTick)
          //         const Icon(
          //           Icons.done,
          //           color: const Color(0xFF2196F3),
          //         ),
          //       const Text(
          //         "\$120.0",
          //         style: TextStyle(
          //           color: Constants.greyColor,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
