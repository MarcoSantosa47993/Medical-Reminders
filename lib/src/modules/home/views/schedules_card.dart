import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_plans/get_plans_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/card.dart';
import 'package:medicins_schedules/src/components/dashboard/card_title.dart';
import 'package:medicins_schedules/src/components/form/my_time_field.dart';
import 'package:medicins_schedules/src/components/schedules/models/schedule.dart';
import 'package:medicins_schedules/src/components/schedules/schedules.dart';
import 'package:medicins_schedules/src/utils/datetime.dart';
import 'package:planning_repository/planning_repository.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HomeSchedulesCard extends StatefulWidget {
  final DateTime currentDate;
  final void Function(DateTime date) onSelectDate;

  const HomeSchedulesCard({
    super.key,
    required this.currentDate,
    required this.onSelectDate,
  });

  @override
  State<HomeSchedulesCard> createState() => _HomeSchedulesCardState();
}

class _HomeSchedulesCardState extends State<HomeSchedulesCard> {
  DateTime firstDateTimeline = findFirstDateOfTheWeek(DateTime.now());
  DateTime lastDateTimeline = findLastDateOfTheWeek(DateTime.now());

  void _onChangeWeek(PickerDateRange? weekRange) {
    setState(() {
      if (weekRange != null) {
        if (weekRange.startDate != null) {
          firstDateTimeline = weekRange.startDate!;
          widget.onSelectDate(firstDateTimeline);
        }
        if (weekRange.endDate != null) {
          lastDateTimeline = weekRange.endDate!;
        }
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

  String get weekLabelrange {
    return "${DateFormat("dd/MM").format(firstDateTimeline)} - ${DateFormat("dd/MM").format(lastDateTimeline)}";
  }

  Schedule currentSchedule = Schedule.data[2];

  void refetchData() {
    context.read<GetPlansBloc>().add(GetPlans(widget.currentDate));
  }

  @override
  void didUpdateWidget(covariant HomeSchedulesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentDate != widget.currentDate) {
      context.read<GetPlansBloc>().add(GetPlans(widget.currentDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetPlansBloc, GetPlansState>(
      builder: (context, state) {
        return DashboardCard(
          flex: 5,
          children: [
            DashboardCardTitle(
              title: "Schedules",
              action: Row(
                children: [
                  TextButton(
                    onPressed: _showWeekDatesPicker,
                    child: Text(weekLabelrange),
                  ),
                  TextButton.icon(
                    onPressed: refetchData,
                    label: Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            DateTimelinePicker(
              currentDate: widget.currentDate,
              firstDateTimeline: firstDateTimeline,
              lastDateTimeline: lastDateTimeline,
              onChange: widget.onSelectDate,
            ),

            switch (state) {
              GetPlansInitial() => loadingContent(),

              GetPlansLoading() => loadingContent(),

              GetPlansSuccess() => successContent(state.plans),

              GetPlansFailure() => failureContent(),
            },

            /*...Schedule.data.map((s) {
              return ScheduleStepper(
                status: s.status,
                isFirst: s == Schedule.data.first,
                isLast: s == Schedule.data.last,
                isSelected: s == currentSchedule,
                subtitle: s.medicinName,
                title: DateFormat("HH:mm").format(s.takeAt),
              );
            }),*/
          ],
        );
      },
    );
  }

  Widget emptyListContent() {
    return Column(
      children: [
        Text("No plans founded"),
        TextButton(onPressed: refetchData, child: Text("Refetch plans")),
      ],
    );
  }

  Widget loadingContent() {
    return Center(child: CircularProgressIndicator());
  }

  Widget failureContent() {
    return Column(
      children: [
        Text("Error on get dependent's plans"),
        TextButton(onPressed: refetchData, child: Text("Refetch plans")),
      ],
    );
  }

  Widget successContent(List<Planning> plans) {
    return BlocBuilder<GetMedicinsBloc, GetMedicinsState>(
      builder: (context, state) {
        String castToName(String medicineId) {
          if (state is GetMedicinsSuccess) {
            return state.medicins
                .singleWhere(
                  (e) => e.id == medicineId,
                  orElse: () => Medicin.empty(),
                )
                .name;
          }

          return "N/A";
        }

        Map<PlanningStatus, ScheduleStatus> status = {
          PlanningStatus.notTaked: ScheduleStatus.notTaken,
          PlanningStatus.taked: ScheduleStatus.taken,
          PlanningStatus.pending: ScheduleStatus.pending,
        };

        return Column(
          children:
              plans.isEmpty
                  ? [emptyListContent()]
                  : plans
                      .map(
                        (e) => ScheduleStepper(
                          status: status[e.taked]!,
                          subtitle: castToName(e.medicineId),
                          title: DateFormat(
                            MyTimeField.format,
                          ).format(e.takeAt),
                          isFirst: e == plans.first,
                          isLast: e == plans.last,
                          isSelected: e.taked == PlanningStatus.pending,
                        ),
                      )
                      .toList(),
        );
      },
    );
  }
}