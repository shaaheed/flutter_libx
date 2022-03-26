import 'package:flutter/material.dart';
import 'icon_text_button.dart';
import 'bottom_nav_item.dart';

class NotchedBottomNav extends StatefulWidget {
  final double height;
  final double notchMargin;
  final NotchedShape notchShape;
  final EdgeInsets padding;
  final ValueChanged<int>? onChange;
  final List<BottomNavItem> items;

  const NotchedBottomNav({
    required this.items,
    this.height = 55,
    this.notchMargin = 7,
    this.notchShape = const CircularNotchedRectangle(),
    this.padding = const EdgeInsets.symmetric(horizontal: 10),
    this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotchedBottomNav();
}

class _NotchedBottomNav extends State<NotchedBottomNav> {
  int _selectedIndex = 0;

  _onChange(int index) {
    widget.onChange?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: widget.notchShape,
      notchMargin: widget.notchMargin,
      child: SizedBox(
        height: widget.height,
        child: Padding(
          padding: widget.padding,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                widget.items.length,
                (index) => IconTextButton(
                  icon: widget.items[index].icon,
                  label: widget.items[index].label,
                  onTap: () {
                    widget.items[index].onTap?.call();
                    _onChange(index);
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  selected: _selectedIndex == index,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
