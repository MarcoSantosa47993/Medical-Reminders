import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/receipts/models/medicin.dart';

class EditMedicineDialog extends StatefulWidget {
  final Medicine medicine;
  final bool isEditable;

  const EditMedicineDialog({
    super.key,
    required this.medicine,
    this.isEditable = true,
  });

  @override
  State<EditMedicineDialog> createState() => _EditMedicineDialogState();
}

class _EditMedicineDialogState extends State<EditMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _obsCtrl;
  late TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.medicine.name);
    _obsCtrl = TextEditingController(text: widget.medicine.observations);
    _qtyCtrl = TextEditingController(text: widget.medicine.quantity.toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _obsCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editable = widget.isEditable;
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Edit Medicine'),
      content: SizedBox(
        width: 312,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                  prefixIcon: Icon(Icons.medication),
                  border: OutlineInputBorder(),
                ),
                readOnly: !editable,
                validator:
                    editable
                        ? (v) => (v?.isEmpty ?? true) ? 'Required' : null
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _obsCtrl,
                decoration: const InputDecoration(
                  labelText: 'Observations',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                readOnly: !editable,
                validator:
                    editable
                        ? (v) => (v?.isEmpty ?? true) ? 'Required' : null
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _qtyCtrl,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  prefixIcon: Icon(Icons.format_list_numbered),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                readOnly: !editable,
                validator:
                    editable
                        ? (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (int.tryParse(v) == null) return 'Must be number';
                          return null;
                        }
                        : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(
            'Back',
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
        if (editable) ...[
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final updated = widget.medicine.copyWith(
                  name: _nameCtrl.text.trim(),
                  observations: _obsCtrl.text.trim(),
                  quantity: int.parse(_qtyCtrl.text.trim()),
                );
                Navigator.pop(context, updated);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ],
    );
  }
}
