import 'package:flutter/material.dart';
import 'center.dart';
import '../extensions/string.extension.dart';

class NoData extends StatelessWidget {
  final String? text;
  final bool showTapToAddOne;

  const NoData({
    this.text,
    this.showTapToAddOne = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CenterWidget(
      children: [
        TextWidget(text: text),
        if (showTapToAddOne) const TapToAddOneWidget(),
      ],
    );
  }
}

class TextWidget extends StatelessWidget {
  final String? text;

  const TextWidget({Key? key, 
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          text ?? "No data".i18n(context),
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class TapToAddOneWidget extends StatelessWidget {
  const TapToAddOneWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          "Tap".i18n(context),
          style: const TextStyle(color: Color(0xFF757575)),
        ),
        const Icon(
          Icons.add,
          size: 24.0,
          color: Color(0xFF757575),
        ),
        Text(
          "to add one".i18n(context),
          style: const TextStyle(color: Color(0xFF757575)),
        ),
      ],
    );
  }
}
