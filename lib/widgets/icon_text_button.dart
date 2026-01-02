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
              ? WidgetStateProperty.resolveWith((states) => Colors.black)
              : WidgetStateProperty.resolveWith((states) => Colors.grey),
          overlayColor: WidgetStateProperty.resolveWith(
            (states) => Colors.grey.withValues(alpha: 0),
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
