import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:user_repository/user_repository.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confPasswordController = TextEditingController();
  final birthdayController = TextEditingController();

  int? role;


  bool _showPassword = false;

  bool isLoadingForm = false;

  _handleShowPassword() => setState(() {
    _showPassword = !_showPassword;
  });

  _onSave() {
    if (_formKey.currentState!.validate()) {
      MyUser myUser = MyUser.empty;
      myUser.name = nameController.text;
      myUser.email = emailController.text;
      myUser.birthday =
          DateFormat(MyDateField.format).tryParse(birthdayController.text) ??
          DateTime.now();
      myUser.role = MyUserRole.values[role ?? 0];
      myUser.pinCode = MyUser.generateRandomPincode();

      log(myUser.toString());

      context.read<SignUpBloc>().add(
        SignUpRequired(myUser, passwordController.text),
      );
    }
  }

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
      case 'password':
        if (v!.isEmpty) {
          return 'New password is required';
        } else if (!RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$',
        ).hasMatch(v)) {
          return 'Please enter a valid password';
        }

      case 'passwordConfirm':
        if (v!.isEmpty) {
          return "Confirm new password is required";
        } else if (v != passwordController.text) {
          return "Passwords doesn't match";
        }
      default:
        return null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpLoading) {
          setState(() {
            isLoadingForm = true;
          });
        } else if (state is SignUpFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: const Text("Registration Error!")));
          setState(() {
            isLoadingForm = false;
          });
        } else if (state is SignUpSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("User registrated and logged!")),
          );
          setState(() {
            isLoadingForm = false;
          });
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20),
        child:
            isLoadingForm
                ? CircularProgressIndicator()
                : Form(
                  key: _formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      const SizedBox(height: 20),
                      MyTextField(
                        label: "Name",
                        controller: nameController,
                        prefixIcon: const Icon(Icons.person_rounded),
                        validator: (v) => validators("name", v),
                      ),
                      MyTextField(
                        label: "Email",
                        controller: emailController,
                        prefixIcon: Icon(Icons.mail_rounded),
                        validator: (v) => validators("email", v),
                      ),

                      MySelectField(
                        value: role,
                        label: "Role",
                        prefixIcon: Icon(Icons.shield),
                        items:
                            MyUserRole.values.map((v) {
                              return DropdownMenuItem(
                                value: v.index,
                                child: Text(v.name),
                              );
                            }).toList(),
                        onChanged: (v) {
                          setState(() {
                            role = v;
                          });
                        },
                        validator: (v) {
                          return validators("role", v);
                        },
                      ),

                      MyDateField(
                        label: "Birthday",
                        prefixIcon: Icon(Icons.calendar_month),
                        controller: birthdayController,
                        validator: (v) => validators("birthday", v),
                      ),

                      MyTextField(
                        label: "New Password",
                        controller: passwordController,
                        prefixIcon: const Icon(Icons.key),
                        validator: (v) => validators("newPassword", v),
                        obscureText: !_showPassword,
                        suffixIcon: IconButton(
                          onPressed: _handleShowPassword,
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),

                      MyTextField(
                        label: "Confirm new password",
                        controller: confPasswordController,
                        prefixIcon: const Icon(Icons.key),
                        obscureText: !_showPassword,
                        validator: (v) => validators("newPasswordConfirm", v),
                      ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: _onSave,
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
