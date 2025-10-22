import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/modules/auth/blocs/sign_in/sign_in_bloc.dart';
import 'package:medicins_schedules/src/modules/auth/blocs/sign_up/sign_up_bloc.dart';
import 'package:medicins_schedules/src/modules/auth/forms/sign_in_form.dart';
import 'package:medicins_schedules/src/modules/auth/forms/sign_up_form.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Expanded(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background2.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 50, horizontal: 100),
              constraints: BoxConstraints(maxWidth: 610, maxHeight: 689),

              child: Column(
                children: [
                  TabBar(
                    controller: tabController,
                    unselectedLabelColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.5),
                    tabs: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Login', style: TextStyle(fontSize: 18)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('Register', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        BlocProvider<SignInBloc>(
                          create:
                              (context) => SignInBloc(
                                context
                                    .read<AuthenticationBloc>()
                                    .userRepository,
                              ),
                          child: const SignInForm(),
                        ),
                        BlocProvider<SignUpBloc>(
                          create:
                              (context) => SignUpBloc(
                                context
                                    .read<AuthenticationBloc>()
                                    .userRepository,
                              ),
                          child: const SignUpForm(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
