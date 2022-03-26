import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const IconTextButton({
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: TextButton(
        style: ButtonStyle(
          foregroundColor: selected
              ? MaterialStateProperty.resolveWith((states) => Colors.black)
              : MaterialStateProperty.resolveWith((states) => Colors.grey),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => Colors.grey.withOpacity(0),
          ),
        ),
        onPressed: onTap,
        child: Column(
          children: [
            Icon(icon),
            Text(label),
          ],
        ),
      ),
    );
  }
}
