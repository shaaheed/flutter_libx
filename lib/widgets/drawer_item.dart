import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final void Function()? onTap;

  const DrawerItem({
    required this.title,
    this.icon,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => {},
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 20,
                color: const Color.fromARGB(255, 112, 112, 112),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(title),
            )
          ],
        ),
      ),
    );
  }
}
