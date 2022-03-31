import 'package:flutter/material.dart';
import './appbar_action.widget.dart';

class IconAppBarAction extends StatefulWidget {
  final String? image;
  final Icon? icon;
  final bool showDefaultIcon;
  final Future<String?> Function()? onTap;

  const IconAppBarAction({
    this.image,
    this.showDefaultIcon = true,
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
      icon: widget.showDefaultIcon ? widget.icon : null,
      onTap: widget.onTap != null
          ? () async {
              var result = await widget.onTap?.call();
              if (result != null && result.isNotEmpty) {
                setState(() {
                  _image = result;
                });
              }
            }
          : null,
    );
  }
}
