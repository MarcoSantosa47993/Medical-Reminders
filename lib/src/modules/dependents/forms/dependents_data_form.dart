import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/components/buttons/delete_button.dart';
import 'package:medicins_schedules/src/components/delete_dialog.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/dependents/blocs/get_dependent/get_dependent_bloc.dart';
import 'package:responsiveness/responsiveness.dart';

class DependentsDataForm extends StatefulWidget {
  const DependentsDataForm({super.key});

  @override
  State<DependentsDataForm> createState() => _DependentsDataFormState();
}

class _DependentsDataFormState extends State<DependentsDataForm> {
  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneAlternativeController = TextEditingController();
  final birthdayController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoadingForm = false;

  bool failOnGet = false;

  String? validators(String varName, String? v) {
    switch (varName) {
      case 'name':
        if (v?.isEmpty ?? true) return 'Name is required';
        break;
      case 'location':
        if (v?.isEmpty ?? true) return 'Location is required';
        break;
      case 'phone':
        if (v?.isEmpty ?? true) return 'Phone is required';
        break;
      case 'phoneAlternative':
        break;
      case 'birthday':
        DateTime? parsedDate = DateFormat(MyDateField.format).tryParse(v!);
        int currentYear = DateTime.now().year;
        if (parsedDate == null) return 'Invalid date';
        if (currentYear - parsedDate.year < 18) {
          return 'Age should be more than 18';
        }
        break;
    }
    return null;
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<GetDependentBloc>().state;

      if (state is GetDependentSuccess) {
        final dep = state.dependent!;
        dep.name = nameController.text;
        dep.birthday =
            DateFormat(MyDateField.format).tryParse(birthdayController.text) ??
            DateTime.now();
        dep.location = locationController.text;
        dep.phone = phoneController.text;
        dep.phone2 = phoneAlternativeController.text;

        context.read<GetDependentBloc>().add(SetDependent(dependent: dep));
      }
    }
  }

  void _onFailureRequests(GetDependentType type) {
    switch (type) {
      case (GetDependentType.getDependent):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Get dependent")));
        setState(() {
          failOnGet = true;
        });
        break;

      case GetDependentType.changeDependent:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Error on Update dependent")),
        );
        break;

      case GetDependentType.removeDependent:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Error on Remove dependent")),
        );

        break;
    }
  }

  void _onSuccessRequests(GetDependentType type, Dependent? data) {
    if (type == GetDependentType.changeDependent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Success on Update Dependent!")),
      );
    } else if (type == GetDependentType.removeDependent) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Success on Remove dependent")),
      );
      context.read<GetDependentsBloc>().add(GetDependents());
    } else if (type == GetDependentType.getDependent) {
      setState(() {
        nameController.text = data!.name;
        birthdayController.text = DateFormat(
          MyDateField.format,
        ).format(data.birthday);
        locationController.text = data.location;
        phoneController.text = data.phone;
        phoneAlternativeController.text = data.phone2;
      });
    }

    setState(() {
      isLoadingForm = false;
      failOnGet = false;
    });
  }

  void _listener(BuildContext context, GetDependentState state) {
    switch (state) {
      case GetDependentInitial _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;

      case GetDependentLoading _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;

      case GetDependentFailure _:
        _onFailureRequests(state.type);
        break;

      case GetDependentSuccess _:
        _onSuccessRequests(state.type, state.dependent);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetDependentBloc, GetDependentState>(
      listener: _listener,
      child:
          isLoadingForm
              ? LinearProgressIndicator()
              : failOnGet
              ? Center(child: Text("Something Went Wrong"))
              : Form(
                key: _formKey,
                child: Column(
                  children: [
                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: 'Name',
                            controller: nameController,
                            prefixIcon: const Icon(Icons.person_rounded),
                            validator: (v) => validators('name', v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyDateField(
                            label: 'Birthday',
                            prefixIcon: const Icon(Icons.calendar_month),
                            controller: birthdayController,
                            validator: (v) => validators('birthday', v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: 'Location',
                            prefixIcon: const Icon(Icons.location_on),
                            controller: locationController,
                            validator: (v) => validators('location', v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: 'Phone',
                            prefixIcon: const Icon(Icons.phone),
                            controller: phoneController,
                            validator: (v) => validators('phone', v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    ResponsiveParent<List<Widget>>(
                      xs: (child) => Column(spacing: 20, children: child),
                      md: (child) => Row(spacing: 20, children: child),
                      child: [
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: 'Phone (Alternative)',
                            prefixIcon: const Icon(Icons.phone),
                            controller: phoneAlternativeController,
                            validator: (v) => validators('phoneAlternative', v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: const SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

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
                    const SizedBox(height: 50),
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
                            text: "Remove Dependent",
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
            title: 'Remove Dependent',
            content: 'Are you sure you want to remove this dependent?',
            icon: Icons.person,
            color: Theme.of(context).colorScheme.error,
            onConfirm: () {
              final state = context.read<GetDependentBloc>().state;

              if (state is GetDependentSuccess) {
                context.read<GetDependentBloc>().add(
                  RemoveDependent(dependentId: state.dependent!.id),
                );
              }
            },
          ),
    );
  }
}
