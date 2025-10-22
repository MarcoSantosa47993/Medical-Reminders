import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/schedules/schedules.dart';
import 'package:medicins_schedules/src/utils/datetime.dart';

class HealthWeekPicker extends StatefulWidget {
  final DateTime currentDate;
  final ValueChanged<DateTime> onChangeDate;

  const HealthWeekPicker({
    super.key,
    required this.currentDate,
    required this.onChangeDate, required Null Function(dynamic date) onDateSelected,
  });

  @override
  State<HealthWeekPicker> createState() => _HealthWeekPickerState();
}

class _HealthWeekPickerState extends State<HealthWeekPicker> {
  late DateTime firstDateTimeline;
  late DateTime lastDateTimeline;

  @override
  void initState() {
    super.initState();
    firstDateTimeline = findFirstDateOfTheWeek(widget.currentDate);
    lastDateTimeline = findLastDateOfTheWeek(widget.currentDate);
  }

  void _onChangeDate(DateTime newDate) {
    setState(() {
      widget.onChangeDate(newDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DateTimelinePicker(
      currentDate: widget.currentDate,
      firstDateTimeline: firstDateTimeline,
      lastDateTimeline: lastDateTimeline,
      onChange: _onChangeDate,
    );
  }
}
