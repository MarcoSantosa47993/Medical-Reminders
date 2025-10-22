import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/health/forms/health_data_form.dart';

class HealthdataFormsCard extends StatelessWidget {
  final DateTime selectedDate;
  final Future<Uint8List?> Function(String id) getImage;

  const HealthdataFormsCard({
    super.key,
    required this.selectedDate,
    required this.getImage,
  });

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 8,
      children: [
        DashboardCardTitle(title: "Heart Rate"),
        SizedBox(height: 20),
        HealthDataForm(selectedDate: selectedDate, getImage: getImage),
      ],
    );
  }
}