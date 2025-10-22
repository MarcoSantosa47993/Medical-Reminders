import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/utils/utils.dart';

class HealthDateRangePickerField extends StatefulWidget {
  final String label;
  final void Function(PickerDateRange?) onSelectRange;
  final PickerDateRange? initialRange;

  const HealthDateRangePickerField({
    super.key,
    required this.label,
    required this.onSelectRange,
    this.initialRange,
  });

  @override
  State<HealthDateRangePickerField> createState() => _HealthDateRangePickerFieldState();
}

class _HealthDateRangePickerFieldState extends State<HealthDateRangePickerField> {
  late TextEditingController _controller;
  PickerDateRange? _selectedRange;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedRange = widget.initialRange;
    _setTextFromRange();
  }

  void _setTextFromRange() {
    if (_selectedRange != null) {
      final start = _selectedRange!.startDate;
      final end = _selectedRange!.endDate ?? _selectedRange!.startDate;
      final formatter = DateFormat('dd/MM/yyyy');
      _controller.text = '${formatter.format(start!)} - ${formatter.format(end!)}';
    } else {
      _controller.clear();
    }
  }

  void _openDateRangeDialog() async {
    PickerDateRange? tempRange = _selectedRange;

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: SfDateRangePicker(
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: tempRange,
              showActionButtons: true,
              onSubmit: (Object? value) {
                if (value is PickerDateRange) {
                  setState(() {
                    _selectedRange = value;
                    _setTextFromRange();
                    widget.onSelectRange(value);
                  });
                }
                Navigator.of(dialogContext).pop();
              },
              onCancel: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      onTap: _openDateRangeDialog,
      decoration: baseInputDecoration(
        context: context,
        label: widget.label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }
}
