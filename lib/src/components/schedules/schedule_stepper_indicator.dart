part of 'schedule_stepper.dart';

class _ScheduleStepperIndicator extends StatelessWidget {
  const _ScheduleStepperIndicator({
    required this.status,
    required this.isSelected,
  });

  final ScheduleStatus status;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    BoxDecoration decoration;
    Color containerColor = Colors.red;

    if (status == ScheduleStatus.pending) {
      icon = Icons.hourglass_bottom_rounded;
      iconColor =
          isSelected
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.surface;
      containerColor = Theme.of(context).colorScheme.outline;
    } else if (status == ScheduleStatus.taken) {
      icon = Icons.check;
      iconColor =
          isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface;
      containerColor = Theme.of(context).colorScheme.primary;
    } else if (status == ScheduleStatus.notTaken) {
      icon = Icons.warning;
      iconColor =
          isSelected
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.surface;
      containerColor =
          isSelected
              ? Theme.of(context).colorScheme.error
              : Theme.of(context).colorScheme.error;
    } else {
      icon = Icons.schedule;
      iconColor =
          isSelected
              ? Theme.of(context).colorScheme.outline
              : Theme.of(context).colorScheme.surface;
      containerColor = Theme.of(context).colorScheme.outline;
    }

    if (isSelected) {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: containerColor, width: 4),
        ),
        color: Theme.of(context).colorScheme.surface,
      );
    } else {
      decoration = BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(color: Theme.of(context).colorScheme.surface, width: 4),
        ),
        color: containerColor,
      );
    }

    return Opacity(
      opacity: status == ScheduleStatus.scheduled ? 0.3 : 1,
      child: Container(
        decoration: decoration,
        child: Center(child: Icon(icon, color: iconColor, size: 22)),
      ),
    );
  }
}
