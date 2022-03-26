export './services/localization.service.dart';
export './services/database.service.dart';
export './extensions/list.extension.dart';
export './extensions/string.extension.dart';
export './services/cache.service.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './extensions/string.extension.dart';

class Utils {
  static const String _notFoundImage = 'assets/images/not_found.png';

  static String isTodayString(
    DateTime? value, {
    BuildContext? context,
    DateFormat? format,
  }) {
    if (value == null) return "";
    bool isText = false;
    String text = "";
    if (Utils.isToday(value)) {
      isText = true;
      text = 'Today';
    } else if (Utils.isYesterday(value)) {
      isText = true;
      text = 'Yesterday';
    } else if (Utils.isTomorrow(value)) {
      isText = true;
      text = 'Tomorrow';
    } else {
      format = format ?? DateFormat('EEEE, dd/MM/yyyy');
      text = format.format(value);
    }
    if (isText && context != null) {
      text = text.i18n(context);
    }
    return text;
  }

  static bool isToday(DateTime value) {
    return isEqualDate(DateTime.now(), value);
  }

  static bool isYesterday(DateTime value) {
    return isEqualDate(
      DateTime.now().subtract(const Duration(days: 1)),
      value,
    );
  }

  static bool isTomorrow(DateTime value) {
    return isEqualDate(
      DateTime.now().add(const Duration(days: 1)),
      value,
    );
  }

  static bool isEqualDate(DateTime? d, DateTime? d2) {
    return d != null &&
        d2 != null &&
        d.day == d2.day &&
        d.month == d2.month &&
        d.year == d2.year;
  }

  static bool isEqualMonthYear(DateTime? d, DateTime? d2) {
    return d != null && d2 != null && d.month == d2.month && d.year == d2.year;
  }

  static RelativeRect getRectFromOffset(Offset? offset) {
    return RelativeRect.fromLTRB(
      offset?.dx ?? 0,
      offset?.dy ?? 0,
      offset?.dx ?? 0,
      offset?.dy ?? 0,
    );
  }

  static Image? image(
    String? image, {
    double height = 40,
    bool nullable = false,
    String? nullImage,
  }) {
    if (nullable && (image == null || image.isEmpty)) return null;
    return Image.asset(
      image ?? nullImage ?? _notFoundImage,
      height: height,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        _notFoundImage,
        height: height + 2,
      ),
    );
  }

  static double progress({
    BuildContext? context,
    double total = 0, // amount
    double consumed = 0, // spent
    double offset = 0,
  }) {
    double progress = offset;
    if (context != null) progress = MediaQuery.of(context).size.width - offset;
    double factor = 1;
    if (consumed != 0 && consumed <= total) {
      factor = consumed / total;
      factor = factor > 1 ? 1 : factor;
    }
    return progress * factor;
  }

  static String daysLeftString({
    BuildContext? context,
    DateTime? start,
    DateTime? end,
  }) {
    if (start == null || end == null) return "";
    var diff = end.difference(start);
    var left = diff.inDays;
    var leftStr = left.toString();
    var daysStr =
        left <= 1 ? "day left".i18n(context) : "days left".i18n(context);
    return "$leftStr $daysStr";
  }
}
