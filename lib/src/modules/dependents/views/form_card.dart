import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/dependents/blocs/get_dependent/get_dependent_bloc.dart';
import 'package:medicins_schedules/src/modules/dependents/components/tooltip.dart';
import 'package:medicins_schedules/src/modules/dependents/forms/dependents_data_form.dart';

class DependentsFormsCard extends StatefulWidget {
  final String? dependentId;
  const DependentsFormsCard({super.key, required this.dependentId});

  @override
  State<DependentsFormsCard> createState() => _DependentsFormsCardState();
}

class _DependentsFormsCardState extends State<DependentsFormsCard> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 8,
      children: [
        if (widget.dependentId == null) ...[
          Icon(Icons.search),
          Center(child: Text("Select a Dependent to start")),
        ] else
          ...content(),
      ],
    );
  }

  List<Widget> content() {
    final userId = context.read<AuthenticationBloc>().state.user!.id;

    return [
      DependentToolbar(dependentId: widget.dependentId!),
      SizedBox(height: 30),
      DashboardCardTitle(title: "Dependent Data"),
      SizedBox(height: 20),
      BlocProvider(
        create:
            (context) =>
                GetDependentBloc(FirebaseDependentsRepo(userId: userId))
                  ..add(GetDependent(dependentId: widget.dependentId!)),

        child: DependentsDataForm(),
      ),
    ];
  }
}
