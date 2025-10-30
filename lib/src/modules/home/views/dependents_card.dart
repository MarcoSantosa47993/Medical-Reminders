import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:responsiveness/responsiveness.dart';

class HomeDependentsCard extends StatefulWidget {
  final Function(String?) onSelectDependent;
  final String? selectedDependent;

  const HomeDependentsCard({
    super.key,
    required this.onSelectDependent,
    required this.selectedDependent,
  });

  @override
  State<HomeDependentsCard> createState() => _HomeDependentsCardState();
}

class _HomeDependentsCardState extends State<HomeDependentsCard> {
  void refetchDepenents() {
    context.read<GetDependentsBloc>().add(GetDependents());
  }

  @override
  void initState() {
    super.initState();
    refetchDepenents();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetDependentsBloc, GetDependentsState>(
      builder: (context, state) {
        return DashboardCard(
          flex: 3,
          children: [
            DashboardCardTitle(title: "My Dependents"),
            SizedBox(height: 20),
            switch (state) {
              GetDependentsInitial _ => loadingContent(),

              GetDependentsLoading _ => loadingContent(),

              GetDependentsFailure _ => failureContent(),

              GetDependentsSuccess _ => successContent(state.dependents),
            },
          ],
        );
      },
    );
  }

  Widget loadingContent() {
    return Center(child: CircularProgressIndicator());
  }

  Widget failureContent() {
    return Column(
      children: [
        Text("Error on get dependents"),
        TextButton(
          onPressed: refetchDepenents,
          child: Text("Refetch dependents"),
        ),
      ],
    );
  }

  Widget successContent(List<Dependent> dependents) {
    return ResponsiveChild(
      xs: MySelectField(
        label: "Dependent",
        items:
            dependents
                .map(
                  (val) =>
                      DropdownMenuItem(value: val.id, child: Text(val.name)),
                )
                .toList(),
        onChanged: (val) {
          widget.onSelectDependent(val);
        },
        value: widget.selectedDependent,
      ),
      lg: Column(
        children:
            dependents.map((e) {
              return DashboardListItem(
                label: e.name,
                value: e.id,
                isSelected: widget.selectedDependent == e.id,
                onSelect: (val) {
                  widget.onSelectDependent(val);
                },
              );
            }).toList(),
      ),
    );
  }
}