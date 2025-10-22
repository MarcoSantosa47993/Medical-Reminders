import 'package:flutter/material.dart';

baseInputDecoration({
  required BuildContext context,
  required String label,
  Widget? suffixIcon,
  Widget? prefixIcon,
  String? errorText,
  bool? alignLabelWithHint,
}) {
  return InputDecoration(
    label: Text(label),
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.primary,
        width: 2.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(),
    fillColor: Colors.grey.shade200,
    filled: false,
    hintStyle: TextStyle(color: Colors.grey[500]),
    errorText: errorText,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2.0,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.error,
        width: 2.0,
      ),
    ),
    alignLabelWithHint: alignLabelWithHint,
  );
}
