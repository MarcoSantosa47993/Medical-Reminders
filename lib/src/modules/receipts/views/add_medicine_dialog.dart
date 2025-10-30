import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/receipts/models/medicin.dart';
import 'package:uuid/uuid.dart';

class AddMedicineDialog extends StatefulWidget {
  final Function(Medicine) onAdd;

  const AddMedicineDialog({super.key, required this.onAdd});

  @override
  State<AddMedicineDialog> createState() => _AddMedicineDialogState();
}

class _AddMedicineDialogState extends State<AddMedicineDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Aspirin');
  final _dosageCtrl = TextEditingController(
    text: 'Pain reliever, anti-inflammatory',
  );
  final _qtyCtrl = TextEditingController(text: '10');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add medicin to receipt', textAlign: TextAlign.start),
      content: SizedBox(
        width: 312,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Medicin Name',
                    prefixIcon: Icon(Icons.medication),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _dosageCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Short Description',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _qtyCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.format_list_numbered),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() != true) return;

                  final name = _nameCtrl.text.trim();
                  final dosage = _dosageCtrl.text.trim();
                  final quantity = int.tryParse(_qtyCtrl.text.trim()) ?? 0;

                  final newMed = Medicine(
                    id: null,
                    name: name,
                    observations: dosage,
                    quantity: quantity,
                  );

                  widget.onAdd(newMed);
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
