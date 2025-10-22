import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/auth/forms/forgot_password_form.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text("Forgot Password"),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [ForgotPasswordForm()],
    );
  }
}
