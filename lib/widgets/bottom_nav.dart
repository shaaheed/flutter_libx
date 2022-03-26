import 'package:flutter/material.dart';
import 'bottom_nav_item.dart';

class BottomNav {
  List<BottomNavItem> items = [];

  BottomNav(
    this.items,
  );

  BottomNavigationBar? create(
    BuildContext context, {
    int selectedIndex = 0,
    ValueChanged<int>? onTap,
  }) {
    if (items.isEmpty) return null;
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: List.generate(
        items.length,
        (index) {
          return BottomNavigationBarItem(
            icon: Icon(items[index].icon),
            label: items[index].label,
          );
        },
      ),
      currentIndex: selectedIndex,
      onTap: (int index) {
        onTap?.call(index);
        items[index].onTap?.call();
      },
      elevation: 3,
    );
  }
}
