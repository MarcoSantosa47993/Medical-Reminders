import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/utils/utils.dart';

class DateTimelinePicker extends StatelessWidget {
  final void Function(DateTime newDate)? onChange;
  final DateTime currentDate;
  final DateTime firstDateTimeline;
  final DateTime lastDateTimeline;

  const DateTimelinePicker({
    super.key,
    this.onChange,
    required this.currentDate,
    required this.firstDateTimeline,
    required this.lastDateTimeline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children:
          _getDatesBetween(firstDateTimeline, lastDateTimeline)
              .map(
                (date) =>
                    _dateItem(context, date, isSameDate(date, currentDate), () {
                      if (onChange != null) {
                        onChange!(date);
                      }
                    }),
              )
              .toList(),
    );
  }

  List<DateTime> _getDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    while (!currentDate.isAfter(endDate)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }

  Widget _dateItem(
    BuildContext context,
    DateTime date,
    bool isSelected,
    void Function()? onSelect,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onSelect,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
          ),
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Text(
                DateFormat("EEE").format(date),
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.outline,
                  fontWeight: FontWeight.w100,
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat("dd").format(date),
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
