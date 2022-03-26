import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import './widgets.dart';

class CircularProgress extends StatelessWidget {
  final double height;
  final double width;
  final double strokeWidth;

  const CircularProgress({
    this.height = 30,
    this.width = 30,
    this.strokeWidth = 3,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterWidget(
      children: <Widget>[
        SizedBox(
          // color: Colors.yellow,
          height: height,
          width: width,
          // child: CircularProgressIndicator(
          //   strokeWidth: strokeWidth,
          // ),
          child: const CupertinoActivityIndicator(
            radius: 12,
          ),
        ),
      ],
    );
  }
}
