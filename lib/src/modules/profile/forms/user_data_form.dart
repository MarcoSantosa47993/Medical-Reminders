import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/profile/blocs/user_data/user_data_bloc.dart';
import 'package:responsiveness/responsiveness.dart';
import 'package:user_repository/user_repository.dart';

class UserDataForm extends StatefulWidget {
  const UserDataForm({super.key});

  @override
  State<UserDataForm> createState() => _UserDataFormState();
}

class _UserDataFormState extends State<UserDataForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final phoneController = TextEditingController();
  final phoneAlternativeController = TextEditingController();
  final birthdayController = TextEditingController();

  int? role;

  final _formKey = GlobalKey<FormState>();
  bool isLoadingForm = false;

  validators(String varName, dynamic v) {
    switch (varName) {
      case 'name':
        if (v!.isEmpty) {
          return "Name is required";
        }
      case 'email':
        if (v!.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(v)) {
          return 'Please enter a valid email';
        }
        return null;
      case 'phone':
        return null;
      case 'birthday':
        DateTime? parsedDate = DateFormat(MyDateField.format).tryParse(v!);
        int currentYear = DateTime.now().year;

        if (parsedDate == null) {
          return "Invalid date";
        } else if (currentYear - parsedDate.year < 18) {
          return "Age should be more than 18";
        }
        return null;
      case 'role':
        if (v == null) {
          return "Role cannot be empty";
        }
      default:
        return null;
    }
    return null;
  }

  onSave() {
    if (_formKey.currentState!.validate()) {
      final u = context.read<AuthenticationBloc>().state.user!;
      u.email = emailController.text;
      u.name = nameController.text;
      u.location = locationController.text;
      u.phone = phoneController.text;
      u.phone2 = phoneAlternativeController.text;
      u.birthday =
          DateFormat(MyDateField.format).tryParse(birthdayController.text) ??
          DateTime.now();
      u.role = MyUserRole.values[role ?? 0];
      u.pinCode = context.read<AuthenticationBloc>().state.user!.pinCode;

      context.read<UserDataBloc>().add(UserDataChange(u));
    }
  }

  @override
  void initState() {
    super.initState();
    final u = context.read<AuthenticationBloc>().state.user!;
    emailController.text = u.email;
    nameController.text = u.name;
    locationController.text = u.location;
    phoneController.text = u.phone;
    phoneAlternativeController.text = u.phone2;
    birthdayController.text = DateFormat(MyDateField.format).format(u.birthday);
    role = u.role.index;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataLoading) {
          setState(() {
            isLoadingForm = true;
          });
        } else if (state is UserDataFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Error on update profile!")),
          );
          setState(() {
            isLoadingForm = false;
          });
        } else if (state is UserDataSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Success on update profile!")),
          );
          setState(() {
            isLoadingForm = false;
          });
        }
      },
      child:
          isLoadingForm
              ? LinearProgressIndicator()
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
                            controller: nameController,
                            prefixIcon: const Icon(Icons.person_rounded),
                            validator: (v) => validators("name", v),
                          ),
                        ),

                        
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Email",
                            controller: emailController,
                            prefixIcon: Icon(Icons.mail_rounded),
                            validator: (v) => validators("email", v),
                            readOnly: true,
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
                            label: "Location",
                            prefixIcon: Icon(Icons.location_on),
                            controller: locationController,
                            validator: (v) => validators("location", v),
                          ),
                        ),

                        
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyTextField(
                            label: "Phone",
                            prefixIcon: Icon(Icons.phone),
                            controller: phoneController,
                            validator: (v) => validators("phone", v),
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
                            label: "Phone (Alternative)",
                            prefixIcon: Icon(Icons.phone),
                            controller: phoneAlternativeController,
                            validator: (v) => validators("phoneAlternative", v),
                          ),
                        ),
                        ResponsiveParent<Widget>(
                          xs: (child) => child,
                          md: (child) => Expanded(child: child),
                          child: MyDateField(
                            label: "Birthday",
                            prefixIcon: Icon(Icons.calendar_month),
                            controller: birthdayController,
                            validator: (v) => validators("birthday", v),
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
                            value: role,
                            label: "Role",
                            items:
                                MyUserRole.values.map((v) {
                                  return DropdownMenuItem(
                                    value: v.index,
                                    child: Text(v.name),
                                  );
                                }).toList(),
                            onChanged: null,
                            validator: (v) {
                              return validators("role", v);
                            },
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
                  ],
                ),
              ),
    );
  }
}
