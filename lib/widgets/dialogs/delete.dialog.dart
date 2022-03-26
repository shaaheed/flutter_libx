import 'package:flutter/material.dart';
import '../dialogs/app_dialog.dart';
import '../../utils.dart';

class DeleteDialog extends AppDialog {
  DeleteDialog(
    BuildContext context,
    void Function() action,
  ) : super(
          titleText: 'Delete?'.i18n(context),
          detailsText:
              'You won\'t be able to undo this action. Do you really want to do delete?'
                  .i18n(context),
          actions: [
            AppDialogAction(
              titleText: 'Yes'.i18n(context),
              onTap: () {
                Navigator.of(context).pop();
                action?.call();
              },
              highlighted: true,
            ),
            AppDialogAction(
              titleText: 'No'.i18n(context),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        );
}
