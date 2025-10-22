import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/form/form.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({super.key});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  validators(String varName, dynamic v) {
    switch (varName) {
      case 'email':
        if (v!.isEmpty) {
          return 'Email is required';
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$').hasMatch(v)) {
          return 'Please enter a valid email';
        }
        return null;

      default:
        return null;
    }
  }

  _onSave() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {"email": emailController.value};

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
          MyTextField(
            label: "Email",
            controller: emailController,
            prefixIcon: Icon(Icons.mail_rounded),
            validator: (v) => validators("email", v),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 5,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                child: const Text('Close'),
              ),
              SizedBox(
                child: FilledButton(onPressed: _onSave, child: Text("Send")),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
