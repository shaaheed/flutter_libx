import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './toast.service.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../extensions/string.extension.dart';

class AppService {
  static BuildContext? _context;
  static Offset? _offset;
  static GlobalKey<ScaffoldState>? _scaffoldKey;

  static BuildContext? getContext() => _context;
  static setContext(BuildContext context) => _context = context;

  static Offset? getCurrentOffset() => _offset;
  static setOffset(Offset offset) => _offset = offset;
  static setOffsetFromDetails(TapDownDetails details) =>
      _offset = details.globalPosition;

  static GlobalKey<ScaffoldState>? generateScaffoldKey() {
    _scaffoldKey = null;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    return _scaffoldKey;
  }

  static GlobalKey<ScaffoldState>? getCurrentScaffoldKey() => _scaffoldKey;

  static Future<bool> launch(
    String urlString, {
    String? errorMessage,
    // bool forceSafariVC,
    // bool forceWebView,
    // bool enableJavaScript,
    // bool enableDomStorage,
    // bool universalLinksOnly,
    // Map<String, String> headers,
    // Brightness statusBarBrightness,
    // String webOnlyWindowName,
  }) async {
    Uri uri = Uri.parse(urlString);
    if (await launcher.canLaunchUrl(uri)) {
      return launcher.launchUrl(uri);
    } else {
      if (errorMessage != null && errorMessage.isNotEmpty) {
        showToast(errorMessage);
      }
    }
    return false;
  }

  // static Future<void> openContact([Map map]) {
  //   return ContactService.open(map);
  // }

  static Future<void>? share({
    required String text,
    String? subject,
    BuildContext? context,
    Rect? sharePositionOrigin,
  }) {
    BuildContext? _context = context ?? getCurrentScaffoldKey()?.currentContext;
    if (_context != null) {
      Rect? _sharePositionOrigin = sharePositionOrigin;
      if (_sharePositionOrigin == null) {
        RenderObject? box = _context.findRenderObject();
        if (box != null) {
          // _sharePositionOrigin = box.localToGlobal(Offset.zero) & box.size;
        }
      }
      return Share.share(
        text,
        subject: subject,
        sharePositionOrigin: _sharePositionOrigin,
      );
    }
    return null;
  }

  /// Stores the given clipboard data on the clipboard.
  static Future<void> copyTextToClipboard(
    String text, {
    BuildContext? context,
    String textType = 'Text',
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    showToast('$textType ${'copied'.i18n(context)}.');
  }

  /// Push a named route onto the navigator that most tightly encloses the given
  /// context.
  static Future<T?> goToPage<T>(
    String routeName, {
    Object? arguments,
  }) {
    BuildContext? context = getCurrentScaffoldKey()?.currentContext;
    if (context != null) {
      return Navigator.pushNamed<T>(context, routeName, arguments: arguments);
    }
    return Future.value(null);
  }

  static void showToast(String? message) {
    BuildContext? context = getCurrentScaffoldKey()?.currentContext;
    if (message != null && context != null) {
      doAfterPostFrameCallback(() {
        ToastService.show(
          message,
          context,
          backgroundColor: Colors.black38,
          duration: 4,
        );
      });
    }
  }

  /// Shows a [SnackBar] at the bottom of the scaffold.
  static void showSnackbar(String message) {
    var scaffoldState = AppService.getCurrentScaffoldKey();
    if (scaffoldState?.currentContext != null) {
      ScaffoldMessenger.of(
        scaffoldState!.currentContext as BuildContext,
      ).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      // scaffoldKey.currentState.showSnackBar();
    }
  }

  /// Shows a modal material design bottom sheet.
  // static Future<T> openBottomSheet<T>(List<BottomSheetModel> models) {
  //   var context = getScaffoldKey()?.currentContext;
  //   if (context != null && models != null && models.length > 0) {
  //     List<EntryWidget> widgets = models.map((model) {
  //       VoidCallback callback;
  //       if (model.callback == null && model.closeOnClick) {
  //         callback = () => popRoute(context);
  //       } else if (model.callback != null && !model.closeOnClick) {
  //         callback = model.callback;
  //       } else if (model.callback != null && model.closeOnClick) {
  //         callback = () {
  //           popRoute(context);
  //           model.callback.call();
  //         };
  //       }
  //       return EntryWidget(
  //         icon: model.icon,
  //         iconWidget: model.iconWidget,
  //         text: model.text,
  //         centered: true,
  //         iconSize: 18,
  //         onTap: callback,
  //       );
  //     }).toList();

  //     double height = 220;
  //     if (widgets.length <= 2) {
  //       height = 100;
  //     } else if (widgets.length <= 3) {
  //       height = 150;
  //     } else if (widgets.length <= 4) {
  //       height = 200;
  //     }

  //     return showModalBottomSheet<T>(
  //       context: context,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: const Radius.circular(20),
  //         ),
  //       ),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       builder: (context) {
  //         return Container(
  //           height: height,
  //           child: SingleChildScrollView(
  //             child: Column(children: widgets),
  //           ),
  //         );
  //       },
  //     );
  //   }
  //   return null;
  // }

  /// Schedule a callback for the end of this frame.
  static void doAfterPostFrameCallback(Function? func) {
    if (func != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        func.call();
      });
    }
  }

  /// Pop the top-most route off the navigator that most tightly encloses the
  /// given context.
  static void popRoute(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }
}
