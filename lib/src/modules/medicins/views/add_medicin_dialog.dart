import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/medicins/blocs/add_medicin/add_medicin_bloc.dart';

class AddMedicinDialog extends StatefulWidget {
  final Function() onAdd;

  const AddMedicinDialog({super.key, required this.onAdd});

  @override
  State<AddMedicinDialog> createState() => _AddMedicinDialogState();
}

class _AddMedicinDialogState extends State<AddMedicinDialog> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final quantityController = TextEditingController();
  final dosePerPeriodController = TextEditingController();
  final observationController = TextEditingController();

  Period? selectedPeriod = Period.values.first;
  final _formKey = GlobalKey<FormState>();
  bool isLoadingForm = false;

  onSuccess() async {
    context.read<GetMedicinsBloc>().add(GetMedicins());
    Navigator.pop(context);
  }

  validators(String varName, dynamic v) {
    switch (varName) {
      case 'name':
        if (v!.isEmpty) {
          return "Name is required";
        }
      case 'type':
        if (v!.isEmpty) {
          return 'Type is required';
        }
      case 'quantity':
        if (v!.isEmpty) {
          return "Quantity is required";
        }
      case 'doseperperiod':
        if (v!.isEmpty) {
          return "Dose per Period is required";
        }
      case 'period':
        if (v == null) {
          return "Period is required";
        }
      default:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add Medicin', textAlign: TextAlign.start),
      content: SizedBox(
        width: 312,
        child: BlocListener<AddMedicinBloc, AddMedicinState>(
          listener: (_, state) {
            if (state is AddMedicinLoading) {
              setState(() {
                isLoadingForm = true;
              });
            } else if (state is AddMedicinFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Error on add Medicin!")),
              );
              setState(() {
                isLoadingForm = false;
              });
            } else if (state is AddMedicinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("New Medicin added!")),
              );
              setState(() {
                isLoadingForm = false;
              });
              widget.onAdd();
              Navigator.pop(context, true);
            }
          },
          child: SingleChildScrollView(
            child:
                isLoadingForm
                    ? Center(child: CircularProgressIndicator())
                    : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: nameController,
                            label: 'Name',
                            prefixIcon: Icon(Icons.medication),
                            validator: (v) => validators("name", v),
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: typeController,
                            label: 'Type',
                            prefixIcon: Icon(Icons.medical_information),
                            validator: (v) => validators("type", v),
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: quantityController,
                            label: 'Quantity',
                            prefixIcon: Icon(Icons.format_list_numbered),
                            validator: (v) => validators("quantity", v),
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: dosePerPeriodController,
                            label: 'Dose Per Period',
                            prefixIcon: Icon(Icons.science),
                            validator: (v) => validators("doseperperiod", v),
                          ),
                          const SizedBox(height: 16),
                          MySelectField(
                            value: selectedPeriod,
                            label: "Period",
                            prefixIcon: Icon(Icons.today),
                            validator: (v) => validators("period", v),
                            items:
                                Period.values.map((v) {
                                  return DropdownMenuItem(
                                    value: v,
                                    child: Text(
                                      v.name[0].toUpperCase() +
                                          v.name.substring(1),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (v) {
                              setState(() {
                                selectedPeriod = v as Period;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: observationController,
                            label: 'Observations',
                            prefixIcon: Icon(Icons.notes),
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: isLoadingForm ? null : () => Navigator.pop(context),
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
                onPressed:
                    isLoadingForm
                        ? null
                        : () {
                          context.read<AddMedicinBloc>().add(
                            AddMedicin(
                              medicin: Medicin(
                                id: "",
                                name: nameController.text,
                                type: typeController.text,
                                quantity:
                                    int.tryParse(quantityController.text) ?? 1,
                                dosePerPeriod:
                                    int.tryParse(
                                      dosePerPeriodController.text,
                                    ) ??
                                    1,
                                period: selectedPeriod!,
                                observations: observationController.text,
                              ),
                            ),
                          );
                        },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
