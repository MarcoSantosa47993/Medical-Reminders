import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/form/form.dart';

class DateFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const DateFormField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return MyDateField(
      label: label,
      controller: controller,
      prefixIcon: const Icon(Icons.calendar_month),
      validator: validator,
    );
  }
}