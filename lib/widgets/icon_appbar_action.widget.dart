import 'package:flutter/material.dart';
import './appbar_action.widget.dart';

class IconAppBarAction extends StatefulWidget {
  final String? image;
  final Icon icon;
  final Future<String> Function()? onTap;

  const IconAppBarAction({
    this.image,
    this.icon = const Icon(
      Icons.arrow_drop_down_rounded,
      color: Colors.black,
    ),
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IconAppBarAction();
}

class _IconAppBarAction extends State<IconAppBarAction> {
  String? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return AppBarAction(
      image: _image,
      icon: widget.icon,
      onTap: widget.onTap != null
          ? () async {
              String? result = await widget.onTap!.call();
              setState(() {
                _image = result;
              });
            }
          : null,
    );
  }
}
