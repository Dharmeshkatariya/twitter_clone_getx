import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

import 'package:intl/intl.dart';

class Utility {
  static void setLoading() {
    Get.defaultDialog(
        title: 'Please wait...',
        barrierDismissible: false,
        content: const CircularProgressIndicator.adaptive());
  }

  static void hideLoading() {
    Get.back();
  }

  static String convertMilliSecondsToDateFormat(double timeInMilli, {String dateFormat = "hh:mm a"}){

    var format = DateFormat(dateFormat);
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMilli.toInt());
    return format.format(date);
  }

  static void showSnack(String title, String msg, {bool isError = false}) {
    Get.snackbar(title, msg,
        backgroundColor: isError
            ? Colors.redAccent
            : Colors.brown,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  static String getTimeAsAmPm(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String getTimeAndDateAsString(DateTime dateTime) {
    var time = getTimeAsAmPm(dateTime);
    final now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return "$time\n\nToday";
    }
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    if (dateTime.day == yesterday.day &&
        dateTime.month == yesterday.month &&
        dateTime.year == yesterday.year) {
      return "$time\n\nYesterday";
    }
    var otherDate = getDateInFormat(dateTime, format: 'MM/dd/yyyy');
    return "$time\n\n$otherDate";
  }

  static DateTime parseStringDate(String dateString,
      {String format = 'yyyy-MM-d', bool localFromUTc = false}) {
    if (dateString.isEmpty) return DateTime.now();
    if (dateString.contains('am') || dateString.contains('pm')) {
      dateString =
          dateString.replaceFirst(' pm', ' PM').replaceFirst(' am', ' AM');
    }
    var date = DateFormat(format).parse(dateString, localFromUTc).toLocal();
    return date;
  }

  static String getDateInFormat(DateTime dateTime,
      {String format = 'd/M/yyyy'}) {
    return DateFormat(format).format(dateTime);
  }

  static bool parseBool(dynamic value) {
    switch (value) {
      case true:
        return true;
      case false:
        return false;
      case 'true':
        return true;
      case 'false':
        return false;
      default:
        return false;
    }
  }


}

