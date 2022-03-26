import 'package:flutter/material.dart';

class AppDialog extends Dialog {
  AppDialog({
    Widget? title,
    String? titleText,
    Widget? details,
    String? detailsText,
    List<AppDialogAction>? actions,
    Key? key,
  }) : super(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 25,
                ),
                child: title ??
                    Text(
                      titleText ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20,
                  bottom: 40,
                ),
                child: details ??
                    Text(
                      detailsText ?? "",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
              ),
              if (actions != null && actions.isNotEmpty)
                ...List<List<Widget>>.generate(
                  actions.length,
                  (index) {
                    return [
                      const Divider(height: 1),
                      InkWell(
                        customBorder: actions.length - 1 == index
                            ? const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0),
                                ),
                              )
                            : null,
                        onTap: actions[index].onTap,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 16,
                              ),
                              child: actions[index].title ??
                                  Text(
                                    actions[index].titleText ?? "",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: actions[index].highlighted
                                          ? FontWeight.w700
                                          : null,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      )
                    ];
                  },
                ).expand((x) => x),
            ],
          ),
          key: key,
        );
}

class AppDialogAction {
  void Function()? onTap;
  Widget? title;
  String? titleText;
  bool highlighted;

  AppDialogAction({
    this.title,
    this.titleText,
    this.onTap,
    this.highlighted = false,
  });
}
