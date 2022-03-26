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
    this.selectFirstOption = false,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  @override
  _RadioOptionsState<T> createState() => _RadioOptionsState<T>();
}

class _RadioOptionsState<T> extends State<RadioOptions<T>> {
  List<RadioModel<T>> _options = [];
  T? _selectedOption;
  ValueChanged<T?>? _onChanged;
  bool _selectFirstOption = true;
  final List<Widget> _widgets = [];

  @override
  void initState() {
    super.initState();

    _selectFirstOption = widget.selectFirstOption;
    _onChanged = widget.onChanged;
    _selectedOption = widget.selected;
    _options = widget.options;

    for (var i = 0; i < _options.length; i++) {
      _widgets.add(Radio<T>(
        value: _options[i].value,
        groupValue:
            _selectedOption == null && _options.isNotEmpty && _selectFirstOption
                ? _options[0].value
                : _selectedOption,
        onChanged: widget.enabled
            ? (value) {
                setState(() {
                  _selectedOption = value;
                });
                _onChanged?.call(value);
              }
            : null,
      ));
      _widgets.add(Text(
        _options[i].label,
        style: const TextStyle(fontSize: 18.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: _widgets);
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
