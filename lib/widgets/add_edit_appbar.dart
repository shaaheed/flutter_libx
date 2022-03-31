import 'package:flutter/material.dart';
import 'back_appbar.dart';

class AddEditAppBar extends BackAppBar {
  AddEditAppBar({
    BuildContext? context,
    GlobalKey<FormState>? formState,
    Function? onSave,
    String? title,
    double elevation = 0.0,
    Key? key,
  }) : super(
          context: context,
          title: title,
          elevation: elevation,
          actions: [
            if (onSave != null)
              IconButton(
                icon: const Icon(Icons.done_rounded),
                onPressed: () {
                  if (formState?.currentState != null) {
                    bool valid = formState!.currentState!.validate();
                    if (valid) onSave();
                  }
                },
              ),
          ],
          key: key,
        );
}
