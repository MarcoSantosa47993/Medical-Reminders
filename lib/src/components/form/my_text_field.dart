import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/utils/utils.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final String? errorMsg;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onSaved;
  final bool readOnly;
  final int? minLines;
  final int? maxLines;
  final bool? alignLabelWithHint;
  final void Function()? onTap;

  const MyTextField({
    super.key,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.errorMsg,
    this.onChanged,
    this.onSaved,
    this.readOnly = false,
    this.controller,
    this.minLines,
    this.maxLines,
    this.alignLabelWithHint = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onSaved: onSaved,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      minLines: obscureText ? 1 : minLines,
      maxLines: obscureText ? 1 : maxLines,
      onTap: onTap,
      decoration: baseInputDecoration(
        context: context,
        label: label,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        errorText: errorMsg,
        alignLabelWithHint: (minLines ?? 1) > 1,
      ),
    );
  }
}
