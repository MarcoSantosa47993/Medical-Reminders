import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/blocs/get_plans/get_plans_bloc.dart';
import 'package:medicins_schedules/src/components/buttons/delete_button.dart';
import 'package:medicins_schedules/src/components/delete_dialog.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/components/form/my_time_field.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_medicines/get_medicines_bloc.dart';
import 'package:medicins_schedules/src/modules/planning/blocs/get_plan_bloc/get_plan_bloc.dart';
import 'package:planning_repository/planning_repository.dart';
import 'package:responsiveness/responsiveness.dart';

class PlanMedicineForm extends StatefulWidget {
  final DateTime selectedDate;
  const PlanMedicineForm({super.key, required this.selectedDate});

  @override
  State<PlanMedicineForm> createState() => _PlanMedicineFormState();
}

class _PlanMedicineFormState extends State<PlanMedicineForm> {
  String medicineId = "";
  final takeAtController = TextEditingController();
  final quantityController = TextEditingController();

  int priority = PlanningPriority.low.index;
  bool emptyStomach = false;

  final _formKey = GlobalKey<FormState>();
  bool isLoadingForm = false;

  bool failOnGet = false;

  String? validators(String varName, String? v) {
    switch (varName) {
      case 'medicine':
        if (v == null || v.isEmpty) return 'Medicine is required';
        break;
      case 'takeAt':
        DateTime? parsedDate = DateFormat(MyTimeField.format).tryParse(v!);
        if (parsedDate == null) return 'Invalid date';
        break;
      case 'priority':
        break;
      case 'emptyStomach':
        break;
      case 'quantity':
        if (v == null || v.isEmpty) return 'Quantity is required';
        if (v.isNotEmpty) {
          final x = int.tryParse(v);
          if (x == null) return 'Invalid number';
          if (x <= 0) return 'Qunatity should be greater than 0';
        }
        break;
    }

    return null;
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<GetPlanBloc>().state;
      final time = DateFormat(MyTimeField.format).parse(takeAtController.text);
      if (state is GetPlanSuccess || state is GetPlanFailure) {
        Planning? pl = (state as GetPlanSuccess).plan;

        Planning plContext = pl;
        plContext.medicineId = medicineId;
        plContext.takeAt = widget.selectedDate.copyWith(
          hour: time.hour,
          minute: time.minute,
        );

        plContext.priority = PlanningPriority.values[priority];
        plContext.jejum = emptyStomach;
        plContext.quantity = int.parse(quantityController.text);

        if (plContext.id == "") {
          // create
          context.read<GetPlanBloc>().add(NewPlan(plan: plContext));
        } else {
          // update
          context.read<GetPlanBloc>().add(SetPlan(plContext));
        }
      }
    }
  }

  void _onFailureRequests(GetPlanType type) {
    switch (type) {
      case GetPlanType.getPlan:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Get plan")));
        setState(() {
          failOnGet = true;
        });
        break;

      case GetPlanType.changePlan:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Update plan")));
        setState(() {
          failOnGet = false;
        });
        break;

      case GetPlanType.removePlan:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Error on Remove dependent")),
        );
        setState(() {
          failOnGet = false;
        });
        break;

      case GetPlanType.addPlan:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Create plan")));
        setState(() {
          failOnGet = false;
        });
        break;
    }

    setState(() {
      isLoadingForm = false;
    });
  }

  void _onSuccessRequests(
    GetPlanType type,
    Planning? data,
    String? errorMessage,
  ) {
    if (type == GetPlanType.changePlan) {
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Update Dependent!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      context.read<GetPlansBloc>().add(GetPlans(widget.selectedDate));
    } else if (type == GetPlanType.addPlan) {
      if (errorMessage == null) {
        context.read<GetMedicinesBloc>().add(GetMedicines());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Create Dependent!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      context.read<GetPlansBloc>().add(GetPlans(widget.selectedDate));
    } else if (type == GetPlanType.removePlan) {
      if (errorMessage == null) {
        context.read<GetMedicinesBloc>().add(GetMedicines());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Remove Dependent!")),
        );
      }

      context.read<GetPlansBloc>().add(GetPlans(widget.selectedDate));
    } else if (type == GetPlanType.getPlan) {
      setState(() {});
    }

    setState(() {
      isLoadingForm = false;
      failOnGet = false;
      medicineId = data!.medicineId;
      takeAtController.text = DateFormat(
        MyTimeField.format,
      ).format(data.takeAt);
      priority = data.priority.index;
      emptyStomach = data.jejum;
      quantityController.text = data.quantity.toString();
    });
  }

  void _listener(BuildContext context, GetPlanState state) {
    switch (state) {
      case GetPlanInitial _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;
      case GetPlanLoading _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;
      case GetPlanFailure():
        _onFailureRequests(state.type);
        break;
      case GetPlanSuccess():
        _onSuccessRequests(state.type, state.plan, state.errorMessage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPlanBloc, GetPlanState>(
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
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        BlocBuilder<GetMedicinesBloc, GetMedicinesState>(
                          builder: (ct, st) {
                            if (st is! GetMedicinesSuccess) return Container();

                            return ResponsiveParent<Widget>(
                              xs: (child) => child,
                              md: (child) => Expanded(child: child),
                              child: MySelectField(
                                label: "Medicine",
                                value: medicineId,
                                validator: (v) => validators('medicine', v),
                                items: [
                                  DropdownMenuItem(
                                    value: "",
                                    child: Text("Not Defined"),
                                  ),
                                  ...st.medicines.map(
                                    (el) => DropdownMenuItem<String>(
                                      value: el.id,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(el.name),
                                          Text(
                                            "${el.dosePerPeriod}/${el.period.name} | stock: ${el.quantity}",
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  setState(() {
                                    medicineId = v ?? "";
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTimeField(
                            label: 'TakeAt',
                            prefixIcon: const Icon(Icons.calendar_month),
                            controller: takeAtController,
                            validator: (v) => validators('takeAt', v),
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
                          child: MySelectField(
                            value: priority,
                            label: "Priority",
                            items:
                                PlanningPriority.values.map((v) {
                                  return DropdownMenuItem(
                                    value: v.index,
                                    child: Text(v.name),
                                  );
                                }).toList(),
                            onChanged: (v) {
                              setState(() {
                                priority = v!;
                              });
                            },
                            validator: (v) {
                              return validators("priority", v.toString());
                            },
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Empty Stomach",
                            readOnly: true,
                            suffixIcon: Switch(
                              value: emptyStomach,
                              onChanged: (v) {
                                setState(() {
                                  emptyStomach = v;
                                });
                              },
                            ),
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
                            controller: quantityController,
                            validator: (v) => validators("quantity", v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: Container(),
                        ),
                      ],
                    ),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
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
                          child: ElevatedButton.icon(
                            onPressed: onSave,
                            icon: Icon(Icons.edit_outlined),
                            label: Text("Update"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    if (context.read<GetPlanBloc>().state is GetPlanSuccess &&
                        (context.read<GetPlanBloc>().state as GetPlanSuccess)
                            .plan
                            .id
                            .isNotEmpty)
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
                              text: "Remove Plan",
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
          (_) => DeleteDialog(
            title: 'Remove Plan',
            content: 'Are you sure you want to remove this plan?',
            icon: Icons.schedule_rounded,
            color: Theme.of(context).colorScheme.error,
            onConfirm: () {
              final state = context.read<GetPlanBloc>().state;

              if (state is GetPlanSuccess && state.plan.id.isNotEmpty) {
                context.read<GetPlanBloc>().add(
                  RemovePlan(state.plan.id, state.plan.medicineId),
                );
              }
            },
          ),
    );
  }
}
