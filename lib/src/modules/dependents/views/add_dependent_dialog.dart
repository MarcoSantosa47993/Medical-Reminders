import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/modules/dependents/blocs/add_dependent/add_dependent_bloc.dart';

class AddDependentDialog extends StatefulWidget {
  final Function() onAdd;

  const AddDependentDialog({super.key, required this.onAdd});

  @override
  State<AddDependentDialog> createState() => _AddDependentDialogState();
}

class _AddDependentDialogState extends State<AddDependentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();

  bool isLoadingForm = false;

  onSuccess() async {
    context.read<GetDependentsBloc>().add(GetDependents());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Add Dependent', textAlign: TextAlign.start),
      content: SizedBox(
        width: 312,
        child: BlocListener<AddDependentBloc, AddDependentState>(
          listener: (_, state) {
            if (state is AddDependentLoading) {
              setState(() {
                isLoadingForm = true;
              });
            } else if (state is AddDependentFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("Error on add dependent!")),
              );
              setState(() {
                isLoadingForm = false;
              });
            } else if (state is AddDependentSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: const Text("New dependent added!")),
              );
              setState(() {
                isLoadingForm = false;
              });
              widget.onAdd();
              Navigator.pop(context, true);
            }
          },
          child: SingleChildScrollView(
            child:
                isLoadingForm
                    ? Center(child: CircularProgressIndicator())
                    : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Pin',
                              prefixIcon: Icon(Icons.qr_code),
                              border: OutlineInputBorder(),
                            ),
                            validator:
                                (v) => (v?.isEmpty ?? true) ? 'Required' : null,
                          ),
                        ],
                      ),
                    ),
          ),
        ),
      ),
      actions: [
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 8,
            children: [
              TextButton(
                onPressed: isLoadingForm ? null : () => Navigator.pop(context),
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed:
                    isLoadingForm
                        ? null
                        : () {
                          context.read<AddDependentBloc>().add(
                            AddDependent(
                              pinCode: int.tryParse(_nameCtrl.text) ?? 0,
                            ),
                          );
                        },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
