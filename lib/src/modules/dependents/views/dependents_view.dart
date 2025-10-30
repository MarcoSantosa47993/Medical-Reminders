import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/dependents/views/dependents_card.dart';
import 'package:medicins_schedules/src/modules/dependents/views/form_card.dart';

class DependentsView extends StatefulWidget {
  const DependentsView({super.key});

  @override
  State<DependentsView> createState() => _DependentsViewState();
}

class _DependentsViewState extends State<DependentsView> {
  String? selectedDependent;

  onSelectDepentent(String? val) {
    if (selectedDependent == val) {
      setState(() {
        selectedDependent = null;
      });
    } else {
      setState(() {
        selectedDependent = val;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthenticationBloc>().state.user!.id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  GetDependentsBloc(FirebaseDependentsRepo(userId: userId))
                    ..add(GetDependents()),
        ),
      ],
      child: DashboardViewBase(
        screenTitle: "Dependents",
        screenSubtitle: "Check all the cared people",
        children: [
          DependentsCard(
            selectedDependent: selectedDependent,
            onSelectDependent: onSelectDepentent,
          ),
          DependentsFormsCard(
            key: ValueKey(selectedDependent),
            dependentId: selectedDependent,
          ),
        ],
      ),
    );
  }
}
