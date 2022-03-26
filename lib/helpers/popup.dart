import 'package:flutter/material.dart';
import '../widgets/dialogs/delete.dialog.dart';
import '../services/app.service.dart';
import '../utils.dart';

class Popup {
  static Future<PopupMenuModel<T>?> showPopupMenu<T>({
    required BuildContext context,
    required Offset? offset,
    required List<PopupMenuModel<T>> items,
  }) async {
    var selected = await showMenu<T>(
      context: context,
      position: Utils.getRectFromOffset(offset),
      items: items.map((x) {
        return PopupMenuItem(
          value: x.value,
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  x.icon,
                  size: 20,
                  color: const Color.fromARGB(255, 112, 112, 112),
                ),
              ),
              Text(x.label.i18n(context)),
            ],
          ),
        );
      }).toList(),
    );

    if (selected != null) {
      var menuItem = items.firstOrDefault((x) => x.value == selected);
      if (menuItem != null) {
        await menuItem.action?.call();
        return menuItem;
      }
    }
    return null;
  }

  static PopupMenuModel<String> editMenuItem(void Function() action) {
    return PopupMenuModel<String>(
      value: 'edit',
      label: 'Edit',
      icon: Icons.edit_outlined,
      action: action,
    );
  }

  static PopupMenuModel<String> deleteMenuItem(
    BuildContext context,
    void Function() action,
  ) {
    return PopupMenuModel<String>(
      value: 'delete',
      label: 'Delete'.i18n(context),
      icon: Icons.delete_outline,
      action: () async {
        showDialog(
          context: context,
          builder: (context) {
            return DeleteDialog(
              context,
              action,
            );
          },
        );
      },
    );
  }

  static void editDeleteMenu<T>(
    BuildContext context,
    T model,
    String editRoute,
    void Function(Object? args) onEdit,
    void Function() onDelete,
  ) {
    Popup.showPopupMenu<String>(
      context: context,
      offset: AppService.getCurrentOffset(),
      items: [
        Popup.editMenuItem(() async {
          var result = await Navigator.pushNamed(
            context,
            editRoute,
            arguments: model,
          );
          onEdit.call(result);
        }),
        Popup.deleteMenuItem(context, onDelete)
      ],
    );
  }
}

class PopupMenuModel<T> {
  T value;
  String label;
  IconData? icon;
  Function? action;

  PopupMenuModel({
    required this.value,
    required this.label,
    this.icon,
    this.action,
  });
}
