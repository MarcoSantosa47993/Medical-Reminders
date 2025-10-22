import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/utils/utils.dart';

class MySelectField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String label;
  final T? value;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? errorText;
  final String? Function(T?)? validator;

  const MySelectField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
    this.errorText,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      items: items,
      onChanged: onChanged,
      value: value,
      validator: validator,
      decoration: baseInputDecoration(
        context: context,
        label: label,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
    );
  }
}
