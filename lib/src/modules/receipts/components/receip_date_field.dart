import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/form/form.dart';

class MyReceiptDateField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? errorMsg;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const MyReceiptDateField({
    super.key,
    required this.label,
    this.controller,
    this.prefixIcon,
    this.validator,
    this.errorMsg,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: controller,
      label: label,
      prefixIcon: prefixIcon,
      validator: validator,
      readOnly: true,
      errorMsg: errorMsg,
      suffixIcon: IconButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () => _selectDate(context),
        icon: const Icon(Icons.calendar_month_rounded),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat dateFormat = DateFormat(format);

    DateTime initialDate = DateTime.now();
    if (controller != null && controller!.text.isNotEmpty) {
      final parsed = dateFormat.tryParse(controller!.text);
      if (parsed != null) {
        initialDate = parsed;
      }
    }

    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      initialDate: initialDate,
      currentDate: DateTime.now(),
    );

    if (newSelectedDate != null && controller != null) {
      final formatted = dateFormat.format(newSelectedDate);
      controller!
        ..text = formatted
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: formatted.length,
            affinity: TextAffinity.upstream,
          ),
        );
      if (onChanged != null) {
        onChanged!(formatted);
      }
    }
  }

  static const format = "dd-MM-yyyy";
}
