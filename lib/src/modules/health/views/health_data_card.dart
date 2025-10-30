import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_repository/health_repository.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/components/schedules/date_timeline_picker.dart';
import 'package:medicins_schedules/src/components/schedules/dialog_date_range.dart';
import 'package:medicins_schedules/src/modules/health/blocs/get_healthdatas/get_health_data_bloc.dart';
import 'package:medicins_schedules/src/utils/datetime.dart';
import 'package:responsiveness/responsiveness.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HealthDataCard extends StatefulWidget {
  final DateTime selectedDate;
  final void Function(DateTime date) onSelectDate;
  final Function(String?) onSelectHealth;
  final String? selectedHealth;
  final Future<Uint8List?> Function(String id) getImage;

  const HealthDataCard({
    super.key,
    required this.selectedHealth,
    required this.onSelectHealth,
    required this.selectedDate,
    required this.onSelectDate,
    required this.getImage,
  });

  @override
  State<HealthDataCard> createState() => _HealthDataCardState();
}

class _HealthDataCardState extends State<HealthDataCard> {
  // timeline utils

  DateTime firstDateTimeline = findFirstDateOfTheWeek(DateTime.now());
  DateTime lastDateTimeline = findLastDateOfTheWeek(DateTime.now());
  final weekController = TextEditingController(text: "");

  void _onChangeWeek(PickerDateRange? weekRange) {
    setState(() {
      if (weekRange != null) {
        if (weekRange.startDate != null) {
          firstDateTimeline = weekRange.startDate!;
          widget.onSelectDate(firstDateTimeline);
          widget.onSelectHealth(null);
        }
        if (weekRange.endDate != null) {
          lastDateTimeline = weekRange.endDate!;
        }
        weekController.text = weekLabelrange;
      }
    });
  }

  _showWeekDatesPicker() {
    showDialog(
      context: context,
      builder: (builder) {
        return DialogDateWeekRange(onSelectTimeRange: _onChangeWeek);
      },
    );
  }

  bool isLoadingData = true;
  List<Health> health = [];

  String get weekLabelrange {
    return "${DateFormat("dd/MM").format(firstDateTimeline)} - ${DateFormat("dd/MM").format(lastDateTimeline)}";
  }

  @override
  void initState() {
    super.initState();
    weekController.text = weekLabelrange;
  }

  @override
  void didUpdateWidget(covariant HealthDataCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      context.read<GetHealthDataBloc>().add(GetHealthData(widget.selectedDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetHealthDataBloc, GetHealthDataState>(
      listener: (context, state) {
        if (state is GetHealthDataLoading) {
          setState(() {
            isLoadingData = true;
          });
        } else if (state is GetHealthDataFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Error on get health registries!")),
          );
          setState(() {
            isLoadingData = false;
            health = [];
          });
        } else if (state is GetHealthDataSuccess) {
          setState(() {
            isLoadingData = false;
            health = state.healthData;
            widget.onSelectHealth(null);
          });
        }
      },
      child: DashboardCard(
        flex: 3,
        floatingActionButton: SizedBox(
          width: 50,
          height: 50,
          child: ResponsiveChild(
            xs: SizedBox.shrink(),
            lg: FloatingActionButton(
              onPressed: () => {widget.onSelectHealth(null)},
              tooltip: 'Add Dependent',
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              elevation: 3,
              child: Icon(Icons.add),
            ),
          ),
        ),
        children: [
          MyTextField(
            label: "Week",
            controller: weekController,
            suffixIcon: const Icon(Icons.calendar_month_rounded),
            readOnly: true,
            onTap: _showWeekDatesPicker,
          ),

          SizedBox(height: 20),

          DateTimelinePicker(
            currentDate: widget.selectedDate,
            firstDateTimeline: firstDateTimeline,
            lastDateTimeline: lastDateTimeline,
            onChange: (v) {
              widget.onSelectDate(v);
              widget.onSelectHealth(null);
            },
          ),

          SizedBox(height: 20),

          isLoadingData
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  if (health.isEmpty)
                    Text("No registries founded")
                  else
                    ...health.map((e) {
                      return item(e);
                    }),
                ],
              ),
        ],
      ),
    );
  }

  Widget item(Health data) {
    final isSelected = data.id == widget.selectedHealth;
    return InkWell(
      onTap: () {
        widget.onSelectHealth(data.id);
      },
      child: Card(
        elevation: isSelected ? 2 : 0,
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                : Theme.of(context).colorScheme.secondaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.value}${data.unit}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.label,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              //if (data.imageAsset != null)
              FutureBuilder(
                future: widget.getImage(data.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Image.memory(
                      snapshot.data!,
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    );
                  } else {
                    return Container();
                  }
                },
              ),

              Icon(
                Icons.arrow_right,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
