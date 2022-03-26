import 'package:flutter/material.dart';

class RowSubtitleWidget extends StatelessWidget {
  final String subtitle;
  final MaterialColor color;

  const RowSubtitleWidget(
    this.subtitle, {
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // const Padding(
        //   padding: const EdgeInsets.all(1.0),
        //   child: ColorFiltered(
        //     colorFilter: Constants.greyscale,
        //     child: Image(
        //       image: const AssetImage('assets/images/icons/icon.png'),
        //       height: 12.0,
        //     ),
        //   ),
        // ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            // '\$20.0 · 21 Dec, 2021'
            child: Text(
              this.subtitle,
              softWrap: true,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ),
        )
      ],
    );
  }
}
