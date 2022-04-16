import 'package:flutter/material.dart';
import '../dialogs/app_dialog.dart';
import '../../utils.dart';

class DeleteDialog extends AppDialog {
  DeleteDialog(
    BuildContext context,
    Future<bool> Function()? action, {
    Key? key,
  }) : super(
          titleText: 'Delete?'.i18n(context),
          detailsText:
              'You won\'t be able to undo this action. Do you really want to delete?'
                  .i18n(context),
          actions: [
            AppDialogAction(
              titleText: 'Yes'.i18n(context),
              onTap: () async {
                var deleted = await action?.call();
                if (deleted != null && deleted) {
                  Navigator.of(context).pop();
                }
              },
              highlighted: true,
            ),
            AppDialogAction(
              titleText: 'No'.i18n(context),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
          key: key,
        );
}
