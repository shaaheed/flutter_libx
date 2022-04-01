import 'package:flutter/material.dart';
import 'package:libx/libx.dart';

class AppButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final bool showLoading;

  const AppButton(
    this.text, {
    this.onTap,
    this.showLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onTap: widget.onTap != null
            ? () {
                if (widget.showLoading) {
                  setState(() {
                    loading = true;
                  });
                }
                widget.onTap!();
                if (widget.showLoading) {
                  setState(() {
                    loading = false;
                  });
                }
              }
            : null,
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 16,
                      ),
                    ),
                    if (widget.showLoading && loading) const CircularProgress()
                  ],
                ),
                height: 45,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(13, 0, 0, 0),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
