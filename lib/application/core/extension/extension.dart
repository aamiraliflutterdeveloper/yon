import 'package:flutter/material.dart';

extension StringExtension on String {
  int toInt() => int.parse(this);
  double toFloat() => double.parse(this);
  String defaultOnEmpty([String defaultValue = ""]) => isEmpty ? defaultValue : this;
}




extension ContextExtension on BuildContext {
  double getHeight([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.height * factor;
  }

  double getWidth([double factor = 1]) {
    assert(factor != 0);
    return MediaQuery.of(this).size.width * factor;
  }

  double get height => getHeight();

  double get width => getWidth();

  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension ClickableExtension on Widget {
  Widget onTap(VoidCallback action, {bool opaque = true}) {
    return GestureDetector(
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      onTap: action,
      child: this,
    );
  }
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return yesterday.day == day && yesterday.month == month && yesterday.year == year;
  }

  DateTime firstDateOfTheWeek() {
    return subtract(Duration(days: weekday - 1));
  }

  DateTime lastDateOfTheWeek() {
    return add(Duration(days: DateTime.daysPerWeek - weekday));
  }
}

