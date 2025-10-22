import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/utils/datetime.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DialogDateWeekRange extends StatefulWidget {
  final void Function(PickerDateRange?)? onSelectTimeRange;

  const DialogDateWeekRange({super.key, this.onSelectTimeRange});

  @override
  State<DialogDateWeekRange> createState() => _DialogDateWeekRangeState();
}

class _DialogDateWeekRangeState extends State<DialogDateWeekRange> {
  final DateRangePickerController _controller = DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),

      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(
              width: 300,
              height: 300,
              child: SfDateRangePicker(
                controller: _controller,
                view: DateRangePickerView.month,
                backgroundColor: Colors.transparent,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Colors.transparent,
                ),

                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: _selectionChanged,
                monthViewSettings: DateRangePickerMonthViewSettings(
                  enableSwipeSelection: false,
                ),
                showNavigationArrow: true,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Select'),
          onPressed: () {
            if (widget.onSelectTimeRange != null) {
              widget.onSelectTimeRange!(_controller.selectedRange);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _selectionChanged(DateRangePickerSelectionChangedArgs args) {
    int firstDayOfWeek = DateTime.sunday % 7;
    int endDayOfWeek = (firstDayOfWeek - 1) % 7;
    endDayOfWeek = endDayOfWeek < 0 ? 7 + endDayOfWeek : endDayOfWeek;
    PickerDateRange ranges = args.value;
    DateTime date1 = ranges.startDate!;
    DateTime date2 = (ranges.endDate ?? ranges.startDate)!;
    if (date1.isAfter(date2)) {
      var date = date1;
      date1 = date2;
      date2 = date;
    }
    int day1 = date1.weekday % 7;
    int day2 = date2.weekday % 7;

    DateTime dat1 = date1.add(Duration(days: (firstDayOfWeek - day1)));
    DateTime dat2 = date2.add(Duration(days: (endDayOfWeek - day2)));

    if (!isSameDate(dat1, ranges.startDate) ||
        !isSameDate(dat2, ranges.endDate)) {
      _controller.selectedRange = PickerDateRange(dat1, dat2);
    }
  }
}
