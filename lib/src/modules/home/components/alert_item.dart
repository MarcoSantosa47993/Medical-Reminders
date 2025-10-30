import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/form/my_time_field.dart';
import 'package:medicins_schedules/src/modules/home/blocs/get_alerts/get_alerts_bloc.dart';
import 'package:medicins_schedules/src/modules/home/blocs/handle_alert/handle_alert_bloc.dart';
import 'package:planning_repository/planning_repository.dart';

class AlertItem extends StatefulWidget {
  final Planning item;
  final String Function(String medicineId) castToName;

  const AlertItem({super.key, required this.item, required this.castToName});

  @override
  State<AlertItem> createState() => _AlertItemState();
}

class _AlertItemState extends State<AlertItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: BlocListener<HandleAlertBloc, HandleAlertState>(
        listener: (context, state) {
          if (state is HandleAlertLoading) {
            setState(() {
              _isLoading = true;
            });
          } else {
            if (state is HandleAlertSuccess) {
              context.read<GetAlertsBloc>().add(GetAlerts());
            }
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Row(
          spacing: 3,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Did you take your medicine at ${DateFormat(MyTimeField.format).format(widget.item.takeAt)}",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    widget.castToName(widget.item.medicineId),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        context.read<HandleAlertBloc>().add(
                          HandleNotTakeMedicine(widget.item),
                        );
                      },
              icon: Icon(Icons.close),
              style: IconButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
            ),
            IconButton.filledTonal(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        context.read<HandleAlertBloc>().add(
                          HandleTakeMedicine(widget.item),
                        );
                      },
              icon: Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }
}