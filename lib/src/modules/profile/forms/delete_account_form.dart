import 'package:flutter/material.dart';

class DeleteAccountForm extends StatefulWidget {
  const DeleteAccountForm({super.key});

  @override
  State<DeleteAccountForm> createState() => _DeleteAccountFormState();
}

class _DeleteAccountFormState extends State<DeleteAccountForm> {
  final _formKey = GlobalKey<FormState>();

  _onSave() {
    if (_formKey.currentState!.validate()) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          Text("Delete Account", style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 24),),
          Text("Are you sure you want to remove this account?"),
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
                child: const Text('Back'),
              ),
              SizedBox(
                child: FilledButton(onPressed: _onSave, 
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Theme.of(context).colorScheme.error)
                  ),
                child: Text("Delete"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
