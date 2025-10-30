import 'package:flutter/material.dart';

openDateDialog(
  BuildContext context,
  void Function()? onSelect, {
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime? newSelectedDate = await showDatePicker(
    context: context,
    firstDate: firstDate ?? DateTime(1940),
    lastDate: lastDate ?? DateTime(2090),
  );

  if (newSelectedDate != null && onSelect != null) {}
}

DateTime findFirstDateOfTheWeek(DateTime dateTime) {
  return dateTime.subtract(Duration(days: dateTime.weekday));
}

DateTime findLastDateOfTheWeek(DateTime dateTime) {
  return dateTime.add(
    Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1),
  );
}

bool isSameDate(DateTime? date1, DateTime? date2) {
  return date1?.year == date2?.year &&
      date1?.month == date2?.month &&
      date1?.day == date2?.day;
}
