import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppTextFormField extends StatefulWidget {
  final Widget? prefixIcon;
  final String? label;
  final String? hintText;
  final TextStyle? errorStyle;
  final double fontSize;
  final double height;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry? contentPadding;
  final bool enabled;
  final void Function(void Function() callback)? onTap;
  final bool readOnly;
  final TextEditingController? controller;
  final String? Function()? value;
  final TextInputType? keyboardType;

  static const Color greyColor = Color(0xFFBDBDBD);
  static const borderColor = Color.fromARGB(20, 0, 0, 0);

  const AppTextFormField({
    this.prefixIcon,
    this.label,
    this.hintText,
    this.errorStyle,
    this.fontSize = 16.0,
    this.height = 50.0,
    this.onChanged,
    this.validator,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.readOnly = false,
    this.controller,
    this.value,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // initState does not call on setState
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      _controller.text = widget.value?.call() ?? "";
    });
    return TextFormField(
      keyboardType: widget.keyboardType,
      onTap: () async {
        widget.onTap?.call(() {
          setState(() {
            _controller.text = widget.value?.call() ?? "";
          });
        });
      },
      style: TextStyle(
        fontSize: widget.fontSize,
        color: !widget.enabled ? const Color.fromARGB(80, 0, 0, 0) : null,
      ),
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(20, 0, 0, 0),
          ),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(20, 0, 0, 0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(50, 0, 0, 0),
          ),
        ),
        label: widget.label != null
            ? Text(
                widget.label as String,
              )
            : null,
        hintText: widget.hintText ?? widget.label,
        hintStyle: const TextStyle(
          color: Color.fromARGB(100, 0, 0, 0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        // errorStyle: widget.errorStyle,
        // contentPadding: widget.contentPadding,
        isDense: true,
      ),
      onChanged: (value) {
        //_controller.text = value;
        // _controller.selection = TextSelection.fromPosition(
        //   TextPosition(
        //     offset: _controller.text.length,
        //   ),
        // );
        widget.onChanged?.call(value);
      },
      validator: widget.validator,
      controller: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
