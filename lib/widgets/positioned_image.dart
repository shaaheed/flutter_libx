import 'package:flutter/material.dart';
import '/utils.dart';

class PositionedImage extends StatelessWidget {
  final double? height;
  final String? image;
  final String? positionedImage;

  const PositionedImage({
    this.height,
    this.image,
    this.positionedImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (positionedImage == null) return Utils.image(image) as Image;
    return Stack(
      children: <Widget>[
        Utils.image(image) as Image,
        Positioned(
          bottom: 0,
          right: 0,
          height: height ?? 15,
          width: height ?? 15,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Utils.image(positionedImage),
            ),
          ),
        ),
      ],
    );
  }
}
