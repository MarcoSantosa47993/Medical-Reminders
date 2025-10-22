import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/app_view.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => AuthenticationBloc(userRepository: FirebaseUserRepo()),
      child: BlocProvider(
        lazy: false,
        create:
            (context) => AuthenticationBloc(
              userRepository: context.read<AuthenticationBloc>().userRepository,
            ),
        child: const MyAppView(),
      ),
    );
  }
}
