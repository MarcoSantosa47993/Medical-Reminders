import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_plans/get_plans_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_medicines/get_medicines_bloc.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_plan_bloc/get_plan_bloc.dart';
import 'package:medicins_schedules/src/modules/planning/views/form_card.dart';
import 'package:medicins_schedules/src/modules/planning/views/planning_list.dart';
import 'package:planning_repository/planning_repository.dart';

class PlanningView extends StatefulWidget {
  final String dependentId;
  const PlanningView({super.key, required this.dependentId});

  @override
  State<PlanningView> createState() => _PlanningViewState();
}

class _PlanningViewState extends State<PlanningView> {
  String? selectedPlan;
  DateTime currentDate = DateTime.now();

  void _onChangeDate(DateTime newDate) {
    setState(() {
      currentDate = newDate;
    });
  }

  onSelectPlan(String? val) {
    if (selectedPlan != val) {
      setState(() {
        selectedPlan = val;
      });
    }
  }

  final medicineController = TextEditingController();
  final takeAtController = TextEditingController();
  final quantityController = TextEditingController();
  String? priority;
  bool jejum = false;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.id;
    final userName = context.read<AuthenticationBloc>().state.user!.name;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => GetPlansBloc(
                FirebasePlanningRepo(
                  userId: userId,
                  dependentId: widget.dependentId,
                ),
              )..add(GetPlans(DateTime.now())),
        ),
        BlocProvider(
          create:
              (context) => GetMedicinesBloc(
                FirebaseMedicinsRepo(
                  dependentId: widget.dependentId,
                  userId: userId,
                ),
              )..add(GetMedicines()),
        ),
        BlocProvider(
          create:
              (context) => GetPlanBloc(
                FirebasePlanningRepo(
                  userId: userId,
                  dependentId: widget.dependentId,
                ),
              )..add(GetPlan("")),
        ),
      ],
      child: DashboardViewBase(
        screenTitle: "Planning",
        screenSubtitle: userName,
        showBackbutton: true,
        children: [
          PlanningList(
            onSelectPlan: onSelectPlan,
            selectedPlan: selectedPlan,
            onSelectDate: _onChangeDate,
            selectedDate: currentDate,
          ),
          PlanningFormCard(
            planId: selectedPlan,
            dependentId: widget.dependentId,
            userId: userId,
            selectedDate: currentDate,
          ),
        ],
      ),
    );
  }
}
