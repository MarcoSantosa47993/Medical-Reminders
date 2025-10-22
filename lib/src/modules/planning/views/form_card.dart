import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/planning/forms/plan_medicine_form.dart';

class PlanningFormCard extends StatefulWidget {
  final String? planId;
  final String dependentId;
  final String userId;
  final DateTime selectedDate;

  const PlanningFormCard({
    super.key,
    required this.planId,
    required this.dependentId,
    required this.userId,
    required this.selectedDate,
  });

  @override
  State<PlanningFormCard> createState() => _PlanningFormCardState();
}

class _PlanningFormCardState extends State<PlanningFormCard> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 8,
      children: [
        DashboardCardTitle(title: "Medicine data"),
        SizedBox(height: 20),
        PlanMedicineForm(selectedDate: widget.selectedDate),
      ],
    );
  }
}
