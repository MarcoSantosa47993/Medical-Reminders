import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:responsiveness/responsiveness.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  validators(String varName, dynamic v) {
    switch (varName) {
      case 'oldPassword':
        if (v!.isEmpty) {
          return 'Old password is required';
        }

      case 'newPassword':
        if (v!.isEmpty) {
          return 'New password is required';
        } else if (!RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$',
        ).hasMatch(v)) {
          return 'Please enter a valid password';
        }

      case 'newPasswordConfirm':
        if (v!.isEmpty) {
          return "Confirm new password is required";
        } else if (v != newPasswordController.text) {
          return "Passwords doesn't match";
        }
      default:
        return null;
    }
    return null;
  }

  onSave() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        "oldPassword": oldPasswordController.text,
        "newPassword": newPasswordController.text,
        "conPassword": newPasswordConfirmController.text,
      };
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
                md: (child) => Expanded(flex: 4, child: child),
                child: MyTextField(
                  label: "Old Password",
                  controller: oldPasswordController,
                  prefixIcon: const Icon(Icons.key),
                  validator: (v) => validators("oldPassword", v),
                  obscureText: true,
                ),
              ),

              
              ResponsiveParent<Widget>(
                xs: (child) => child,
                md: (child) => Expanded(flex: 4, child: child),
                child: MyTextField(
                  label: "New Password",
                  controller: newPasswordController,
                  prefixIcon: const Icon(Icons.key),
                  validator: (v) => validators("newPassword", v),
                  obscureText: true,
                ),
              ),

              
              ResponsiveParent<Widget>(
                xs: (child) => child,
                md: (child) => Expanded(flex: 4, child: child),
                child: MyTextField(
                  label: "Confirm new password",
                  controller: newPasswordConfirmController,
                  prefixIcon: const Icon(Icons.key),
                  obscureText: true,
                  validator: (v) => validators("newPasswordConfirm", v),
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
                  icon: Icon(Icons.key),
                  label: Text("Change Password"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
