import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_repository/health_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicins_schedules/src/components/buttons/delete_button.dart';
import 'package:medicins_schedules/src/components/delete_dialog.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/health/blocs/get_healthdata/get_health_bloc.dart';
import 'package:medicins_schedules/src/modules/health/blocs/get_healthdatas/get_health_data_bloc.dart';
import 'package:responsiveness/responsiveness.dart';

class HealthDataForm extends StatefulWidget {
  final DateTime selectedDate;
  final Future<Uint8List?> Function(String id) getImage;

  const HealthDataForm({
    super.key,
    required this.selectedDate,
    required this.getImage,
  });

  @override
  State<HealthDataForm> createState() => _HealthDataFormState();
}

class _HealthDataFormState extends State<HealthDataForm> {
  final labelController = TextEditingController();
  final valueController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();

  Uint8List? imageFile;

  final _formKey = GlobalKey<FormState>();

  bool isCreate = true;

  bool isLoadingForm = false;
  bool failOnGet = false;

  void _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final img = await pickedFile.readAsBytes();
      setState(() {
        imageFile = img;
      });
    }
  }

  String? validators(String varName, String? v) {
    switch (varName) {
      case 'label':
        if (v == null || v.isEmpty) return "Label is required";
        break;
      case 'value':
        if (v == null || v.isEmpty) return "Value is required";
        if (double.tryParse(v) == null) return "Enter a valid number";
        break;
      case 'unit':
        if (v == null || v.isEmpty) return "Unit is required";
        break;
    }
    return null;
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      final state = context.read<GetHealthBloc>().state;
      final date = widget.selectedDate;

      if (state is GetHealthSuccess) {
        final h = state.health;
        h.date = date;
        h.label = labelController.text;
        h.value = double.parse(valueController.text);
        h.unit = unitController.text;

        if (h.id == "") {
          // create
          context.read<GetHealthBloc>().add(AddHealth(h, image: imageFile));
        } else {
          // update
          context.read<GetHealthBloc>().add(SetHealth(h, image: imageFile));
        }
      }
    }
  }

  void _onFailureRequests(GetHealthType type) {
    switch (type) {
      case GetHealthType.getHealth:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Get health")));
        setState(() {
          failOnGet = true;
        });
        break;

      case GetHealthType.changeHealth:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Update health")));
        setState(() {
          failOnGet = false;
        });
        break;

      case GetHealthType.removeHealth:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Remove health")));
        setState(() {
          failOnGet = false;
        });
        break;

      case GetHealthType.addHealth:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: const Text("Error on Create health")));
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
    GetHealthType type,
    Health data,
    String? errorMessage,
  ) async {
    if (type == GetHealthType.changeHealth) {
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Update health!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }

      context.read<GetHealthDataBloc>().add(GetHealthData(widget.selectedDate));
    } else if (type == GetHealthType.addHealth) {
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Create health!")),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
      context.read<GetHealthDataBloc>().add(GetHealthData(widget.selectedDate));
    } else if (type == GetHealthType.removeHealth) {
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text("Success on Remove health!")),
        );
      }

      context.read<GetHealthDataBloc>().add(GetHealthData(widget.selectedDate));
    } else if (type == GetHealthType.getHealth) {
      setState(() {});
    }

    final img =
        data.id.isNotEmpty
            ? data.image != null
                ? await widget.getImage(data.id)
                : null
            : null;
    setState(() {
      isLoadingForm = false;
      failOnGet = false;
      labelController.text = data.label;
      unitController.text = data.unit;
      valueController.text = data.value.toString();
      imageFile = img;
      isCreate = data.id.isEmpty;
    });
  }

  void _listener(BuildContext context, GetHealthState state) {
    switch (state) {
      case GetHealthInitial _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;
      case GetHealthLoading _:
        setState(() {
          isLoadingForm = true;
          failOnGet = false;
        });
        break;
      case GetHealthFailure _:
        _onFailureRequests(state.type);
        break;
      case GetHealthSuccess _:
        _onSuccessRequests(state.type, state.health, state.errorMessage);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetHealthBloc, GetHealthState>(
      listener: _listener,
      child:
          isLoadingForm
              ? LinearProgressIndicator()
              : failOnGet
              ? Center(child: Text("Something went wrong"))
              : Form(
                key: _formKey,
                child: Column(
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                          color: Colors.teal[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            imageFile != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image, color: Colors.teal),
                                    Text(
                                      'Upload Image',
                                      style: TextStyle(color: Colors.teal),
                                    ),
                                  ],
                                ),
                      ),
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
                            label: "Label",
                            controller: labelController,
                            validator: (v) => validators("label", v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Value",
                            controller: valueController,
                            validator: (v) => validators("value", v),
                            keyboardType: TextInputType.number,
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
                            label: "Unit",
                            controller: unitController,
                            validator: (v) => validators("unit", v),
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
                                children: [
                                  Icon(Icons.edit_outlined, size: 20),
                                  SizedBox(width: 8),
                                  Text(isCreate ? 'Create' : 'Update'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    if (!isCreate)
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
                              text: "Remove Health",
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
            title: 'Remove Register',
            content: 'Are you sure you want to remove this register?',
            icon: Icons.schedule_rounded,
            color: Theme.of(context).colorScheme.error,
            onConfirm: () {
              final state = context.read<GetHealthBloc>().state;

              if (state is GetHealthSuccess && state.health.id.isNotEmpty) {
                context.read<GetHealthBloc>().add(
                  RemoveHealth(state.health.id),
                );
              }
            },
          ),
    );
  }
}
