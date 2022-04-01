import 'package:flutter/material.dart';

class RadioOptions<T> extends StatefulWidget {
  final List<RadioModel<T>> options;
  final ValueChanged<T?>? onChanged;
  final T? selected;
  final bool selectFirstOption;
  final bool enabled;

  const RadioOptions({
    required this.options,
    required this.onChanged,
    this.selected,
    this.selectFirstOption = true,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  _RadioOptionsState<T> createState() => _RadioOptionsState<T>();
}

class _RadioOptionsState<T> extends State<RadioOptions<T>> {
  T? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selected;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildWidgets(),
    );
  }

  List<Widget> _buildWidgets() {
    List<Widget> _widgets = [];
    for (var i = 0; i < widget.options.length; i++) {
      _widgets.add(Radio<T>(
        value: widget.options[i].value,
        groupValue: _selectedOption == null &&
                widget.options.isNotEmpty &&
                widget.selectFirstOption
            ? widget.options[0].value
            : _selectedOption,
        onChanged: widget.enabled
            ? (value) {
                setState(() {
                  _selectedOption = value;
                });
                widget.onChanged?.call(value);
              }
            : null,
      ));
      _widgets.add(
        InkWell(
          child: Text(
            widget.options[i].label,
            style: const TextStyle(fontSize: 18.0),
          ),
          onTap: widget.enabled
              ? () {
                  setState(() {
                    _selectedOption = widget.options[i].value;
                  });
                  widget.onChanged?.call(widget.options[i].value);
                }
              : null,
        ),
      );
    }
    return _widgets;
  }
}

class RadioModel<T> {
  RadioModel({
    required this.value,
    required this.label,
  });
  T value;
  String label;
}
