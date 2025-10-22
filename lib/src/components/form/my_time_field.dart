import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/form/my_text_field.dart';

class MyTimeField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? errorMsg;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;

  const MyTimeField({
    super.key,
    required this.label,
    required this.controller,
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
          _selectTime(context);
        },
        icon: Icon(Icons.calendar_month_rounded),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final initTime =
        DateFormat(format).tryParse(controller.text) ?? DateTime.now();
    TimeOfDay? newSelectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: initTime.hour, minute: initTime.minute),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (newSelectedTime != null) {
      controller
        ..text = DateFormat(format).format(
          DateTime.now().copyWith(
            hour: newSelectedTime.hour,
            minute: newSelectedTime.minute,
          ),
        )
        ..selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller.text.length,
            affinity: TextAffinity.upstream,
          ),
        );
    }
  }

  static final format = "HH:mm";
}
