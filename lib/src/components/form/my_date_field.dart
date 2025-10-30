import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/form/form.dart';

class MyDateField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String? errorMsg;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  const MyDateField({
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
      onChanged: onChanged,
      suffixIcon: IconButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () {
          _selectDate(context);
        },
        icon: Icon(Icons.calendar_month_rounded),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2040),
      initialDate: DateTime.now(), // Define a data atual como inicial
      currentDate: DateFormat(format).tryParse(controller?.text ?? ""),
    );

    if (newSelectedDate != null && controller != null) {
      controller!
        ..text = DateFormat(format).format(newSelectedDate)
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller!.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  static final format = "y-MM-dd";
}
