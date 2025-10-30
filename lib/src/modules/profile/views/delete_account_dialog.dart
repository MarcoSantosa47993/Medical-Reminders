import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/modules/profile/forms/delete_account_form.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Icon(
        Icons.person_rounded,
        color: Theme.of(context).colorScheme.error,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [DeleteAccountForm()],
    );
  }
}
