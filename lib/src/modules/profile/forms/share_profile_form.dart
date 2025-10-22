import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareProfileForm extends StatefulWidget {
  const ShareProfileForm({super.key});

  @override
  State<ShareProfileForm> createState() => _ShareProfileFormState();
}

class _ShareProfileFormState extends State<ShareProfileForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        spacing: 20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text("Share Account", style: TextStyle(fontSize: 24))],
          ),
          Column(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: QrImageView(
                  data:
                      context
                          .read<AuthenticationBloc>()
                          .state
                          .user!
                          .pinCode
                          .toString(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 2.0,
                children: [
                  Text(
                    "Pin:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    context
                        .read<AuthenticationBloc>()
                        .state
                        .user!
                        .pinCode
                        .toString(),
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
            ],
          ),
        ],
      ),
    );
  }
}
