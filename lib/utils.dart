import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message,
      {Duration? duration}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    SnackBar snackBar = SnackBar(
      content: Text(message),
      duration: (duration != null) ? duration : Duration(seconds: 4),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String formatAmount(double? amount) {
    final numberFormat = NumberFormat("#,##0.00", "en_PH");
    return '₱${numberFormat.format(amount)}';
  }

  static String dateTimeToString(DateTime? dateTime) {
    return DateFormat.yMMMd().format(dateTime!);
  }

  static DateTime stringToDateTime(String dateTime) {
    return DateFormat.yMMMd().parse(dateTime);
  }
}
