import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/schedules/models/schedule.dart';
import 'package:timeline_tile/timeline_tile.dart';

part 'schedule_stepper_indicator.dart';

class ScheduleStepper extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final String title;
  final String subtitle;
  final ScheduleStatus status;
  final bool isSelected;

  const ScheduleStepper({
    super.key,
    this.isFirst = false,
    this.isLast = false,
    this.title = "Title",
    this.subtitle = "Subtitle",
    this.isSelected = false,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,

      isFirst: isFirst,
      isLast: isLast,
      endChild: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.centerLeft,
        constraints: const BoxConstraints(minHeight: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      indicatorStyle: IndicatorStyle(
        width: 45,
        height: 45,
        indicator: _ScheduleStepperIndicator(
          status: status,
          isSelected: isSelected,
        ),
        drawGap: true,
      ),
      beforeLineStyle: LineStyle(
        color:
            status == ScheduleStatus.taken
                ? Theme.of(context).colorScheme.primary
                : status == ScheduleStatus.notTaken
                ? Theme.of(context).colorScheme.error
                : status == ScheduleStatus.pending
                ? Theme.of(context).colorScheme.outline
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
      ),
    );
  }
}
