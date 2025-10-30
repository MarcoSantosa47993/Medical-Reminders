import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/get_plans/get_plans_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/my_text_field.dart';
import 'package:medicins_schedules/src/components/form/my_time_field.dart';
import 'package:medicins_schedules/src/components/schedules/schedules.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_medicines/get_medicines_bloc.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_plan_bloc/get_plan_bloc.dart';
import 'package:medicins_schedules/src/utils/datetime.dart';
import 'package:planning_repository/planning_repository.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PlanningList extends StatefulWidget {
  final Function(String?) onSelectPlan;
  final String? selectedPlan;
  final DateTime selectedDate;
  final void Function(DateTime date) onSelectDate;

  //final void Function(DocumentReference docRef) onItemSelected;

  const PlanningList({
    super.key,
    required this.selectedPlan,
    required this.onSelectPlan,
    required this.selectedDate,
    required this.onSelectDate,
  });

  //static const _priorityWeight = {'High': 3, 'Medium': 2, 'Low': 1};

  @override
  State<PlanningList> createState() => _PlanningListState();
}

class _PlanningListState extends State<PlanningList> {
  // timeline utils

  DateTime firstDateTimeline = findFirstDateOfTheWeek(DateTime.now());
  DateTime lastDateTimeline = findLastDateOfTheWeek(DateTime.now());
  final weekController = TextEditingController(text: "");

  String get weekLabelrange {
    return "${DateFormat("dd/MM").format(firstDateTimeline)} - ${DateFormat("dd/MM").format(lastDateTimeline)}";
  }

  void _onChangeWeek(PickerDateRange? weekRange) {
    setState(() {
      if (weekRange != null) {
        if (weekRange.startDate != null) {
          firstDateTimeline = weekRange.startDate!;
          context.read<GetPlansBloc>().add(GetPlans(firstDateTimeline));
          widget.onSelectDate(firstDateTimeline);
          widget.onSelectPlan(null);
          context.read<GetPlanBloc>().add(GetPlan(""));
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
  List<Planning> plans = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPlansBloc, GetPlansState>(
      listener: (context, state) {
        if (state is GetPlansLoading) {
          setState(() {
            isLoadingData = true;
          });
        } else if (state is GetPlansFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: const Text("Error on get plans!")));
          setState(() {
            isLoadingData = false;
            plans = [];
          });
        } else if (state is GetPlansSuccess) {
          setState(() {
            isLoadingData = false;
            plans = state.plans;
            widget.onSelectPlan(null);
          });
        }
      },
      child: DashboardCard(
        flex: 2,
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
              context.read<GetPlansBloc>().add(GetPlans(v));
              widget.onSelectDate(v);
              widget.onSelectPlan(null);
              context.read<GetPlanBloc>().add(GetPlan(""));
            },
          ),

          SizedBox(height: 20),

          BlocBuilder<GetMedicinesBloc, GetMedicinesState>(
            builder: (medicinesContext, medicinesState) {
              final isSuccess = medicinesState is GetMedicinesSuccess;

              String getMedicineById(String id) {
                try {
                  if (isSuccess) {
                    return medicinesState.medicines
                        .firstWhere(
                          (m) => m.id == id,
                          orElse: () => Medicin.empty(),
                        )
                        .name;
                  }

                  return "";
                } catch (e) {
                  return "";
                }
              }

              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                clipBehavior: Clip.hardEdge,
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    _header2(),
                    isLoadingData
                        ? TableRow(
                          decoration: BoxDecoration(color: Colors.white),
                          children: [
                            TableCell(child: Container()),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            TableCell(child: Container()),
                          ],
                        )
                        : plans.isEmpty
                        ? TableRow(
                          decoration: BoxDecoration(color: Colors.white),
                          children: [
                            TableCell(child: Container()),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(child: Text("No data found")),
                              ),
                            ),
                            TableCell(child: Container()),
                          ],
                        )
                        : TableRow(
                          children: [
                            TableCell(child: Container()),
                            TableCell(child: Container()),
                            TableCell(child: Container()),
                          ],
                        ),
                    ...plans.map(
                      (pl) => TableRow(
                        decoration: BoxDecoration(
                          color:
                              widget.selectedPlan == pl.id
                                  ? Colors.grey.shade100
                                  : Colors.white,
                        ),
                        children: [
                          TableCell(
                            child: InkWell(
                              onTap: () {
                                context.read<GetPlanBloc>().add(GetPlan(pl.id));
                                widget.onSelectPlan(pl.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  getMedicineById(pl.medicineId),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),

                          TableCell(
                            child: InkWell(
                              onTap: () {
                                context.read<GetPlanBloc>().add(GetPlan(pl.id));
                                widget.onSelectPlan(pl.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      DateFormat(
                                        MyTimeField.format,
                                      ).format(pl.takeAt),
                                    ),
                                    if (pl.jejum)
                                      Text(
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall!.copyWith(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                        ),
                                        "(empty stomach)",
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          TableCell(
                            child: InkWell(
                              onTap: () {
                                context.read<GetPlanBloc>().add(GetPlan(pl.id));
                                widget.onSelectPlan(pl.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Center(
                                  child: Icon(
                                    Icons.circle,
                                    color:
                                        pl.taked == PlanningStatus.pending
                                            ? Colors.grey
                                            : pl.taked == PlanningStatus.taked
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TableRow(
                      decoration: BoxDecoration(color: Colors.white),
                      children: [
                        TableCell(child: Container()),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: TextButton(
                              onPressed: () {
                                context.read<GetPlanBloc>().add(GetPlan(""));
                                widget.onSelectPlan(null);
                              },
                              child: const Text(
                                "Add",
                                style: TextStyle(color: Colors.teal),
                              ),
                            ),
                          ),
                        ),
                        TableCell(child: Container()),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  _header2() {
    return TableRow(
      children: [
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Text(
              "Medicine",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Text(
              "Time",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Text(
              "Taken",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
