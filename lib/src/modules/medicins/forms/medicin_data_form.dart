import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/components/buttons/delete_button.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/medicins/blocs/get_medicin/get_medicin_bloc.dart';
import 'package:medicins_schedules/src/modules/medicins/views/delete_medicin_dialog.dart';
import 'package:responsiveness/responsiveness.dart';

class MedicinDataForm extends StatefulWidget {
  const MedicinDataForm({super.key});

  @override
  State<MedicinDataForm> createState() => _MedicinDataFormState();
}

class _MedicinDataFormState extends State<MedicinDataForm> {
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final quantityController = TextEditingController();
  final dosePerPeriodController = TextEditingController();
  final observationController = TextEditingController();

  Period? selectedPeriod;

  final _formKey = GlobalKey<FormState>();

  bool isLoadingForm = false;
  bool failOnGet = false;

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

  void onSave() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<GetMedicinBloc>().state;

      if (state is GetMedicinSuccess) {
        final med = state.medicin!;
        med.name = nameController.text;
        med.type = typeController.text;
        med.quantity = int.tryParse(quantityController.text) ?? 1;
        med.dosePerPeriod = int.tryParse(dosePerPeriodController.text) ?? 1;
        med.period = selectedPeriod!;
        med.observations = observationController.text;

        context.read<GetMedicinBloc>().add(SetMedicin(medicin: med));
      }
    }
  }

  void _onFailureRequests(GetMedicinType type) {
    switch (type) {
      case (GetMedicinType.getMedicin):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Get Medicin")));
        setState(() {
          failOnGet = true;
        });
        break;

      case GetMedicinType.changeMedicin:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Error on Update Medicin")),
        );
        break;

      case GetMedicinType.removeMedicin:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Error on Remove Medicin")),
        );

        break;
    }
  }

  void _onSuccessRequests(GetMedicinType type, Medicin? data) {
    if (type == GetMedicinType.changeMedicin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Success on Update Medicin!")),
      );
    } else if (type == GetMedicinType.removeMedicin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Success on Remove Medicin")),
      );
      context.read<GetMedicinsBloc>().add(GetMedicins());
    } else if (type == GetMedicinType.getMedicin) {
      setState(() {
        nameController.text = data!.name;
        typeController.text = data.type;
        quantityController.text = data.quantity.toString();
        dosePerPeriodController.text = data.dosePerPeriod.toString();
        selectedPeriod = data.period;
        observationController.text = data.observations;
      });
    }

    setState(() {
      isLoadingForm = false;
      failOnGet = false;
    });
  }

  void _listener(BuildContext context, GetMedicinState state) {
    switch (state) {
      case GetMedicinInitial _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;

      case GetMedicinLoading _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;

      case GetMedicinFailure _:
        _onFailureRequests(state.type);
        break;

      case GetMedicinSuccess _:
        _onSuccessRequests(state.type, state.medicin);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetMedicinBloc, GetMedicinState>(
      listener: _listener,
      child:
          isLoadingForm
              ? LinearProgressIndicator()
              : failOnGet
              ? Center(child: Text("Something Went Wrong"))
              : Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  children: [
                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md:
                          (child) => Row(
                            spacing: 20,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: child,
                          ),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Name",
                            prefixIcon: const Icon(Icons.medication),
                            controller: nameController,
                            validator: (v) => validators("name", v),
                          ),
                        ),

                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Type",
                            prefixIcon: Icon(Icons.medical_information),
                            controller: typeController,
                            validator: (v) => validators("type", v),
                          ),
                        ),
                      ],
                    ),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Quantity",
                            prefixIcon: Icon(Icons.format_list_numbered),
                            controller: quantityController,
                            validator: (v) => validators("quantity", v),
                          ),
                        ),

                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Dose per Period",
                            prefixIcon: Icon(Icons.science),
                            controller: dosePerPeriodController,
                            validator: (v) => validators("doseperperiod", v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MySelectField(
                            value: selectedPeriod,
                            label: "Period",
                            prefixIcon: Icon(Icons.today),
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
                            validator: (v) {
                              return validators("period", v);
                            },
                          ),
                        ),
                      ],
                    ),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Observations",
                            prefixIcon: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Transform.translate(
                                  offset: Offset(0, -28),
                                  child: Icon(Icons.notes),
                                ),
                              ],
                            ),
                            controller: observationController,
                            validator: (v) => validators("observation", v),
                            minLines: 4,
                            maxLines: 5,
                          ),
                        ),
                      ],
                    ),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(flex: 8, child: child),
                          child: Container(),
                        ),
                        ResponsiveParent<Widget>(
                          xs:
                              (child) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: child,
                              ),
                          md: (child) => Expanded(flex: 4, child: child),
                          child: SizedBox(
                            width: 261,
                            child: ElevatedButton(
                              onPressed: onSave,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                alignment: Alignment.center,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(Icons.edit_outlined, size: 20),
                                  SizedBox(width: 8),
                                  Text('Update'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs:
                              (child) => SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: child,
                              ),
                          md: (child) => Expanded(flex: 4, child: child),
                          child: DeleteButton(
                            onPressed: () => _showDeleteDialog(),
                            text: "Remove Medicin",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder:
          (_) => DeleteMedicinDialog(
            title: 'Remove Medicin',
            content: 'Are you sure you want to remove this medicin?',
            icon: Icons.medical_information_sharp,
            color: Theme.of(context).colorScheme.error,
            onConfirm: () {
              final state = context.read<GetMedicinBloc>().state;

              if (state is GetMedicinSuccess) {
                context.read<GetMedicinBloc>().add(
                  RemoveMedicin(medicinId: state.medicin!.id),
                );
              }
            },
          ),
    );
  }
}
