import 'package:dependents_repository/dependents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_dependents/get_dependents_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/dependents/blocs/add_dependent/add_dependent_bloc.dart';
import 'package:medicins_schedules/src/modules/dependents/views/add_dependent_dialog.dart';
import 'package:responsiveness/responsiveness.dart';

class DependentsCard extends StatefulWidget {
  final Function(String?) onSelectDependent;
  final String? selectedDependent;

  const DependentsCard({
    super.key,
    required this.onSelectDependent,
    required this.selectedDependent,
  });

  @override
  State<DependentsCard> createState() => _DependentsCardState();
}

class _DependentsCardState extends State<DependentsCard> {
  final searchController = TextEditingController(text: "");

  bool isLoadingData = true;
  List<Dependent> dependents = [];
  List<Dependent> filteredDependents = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filteredDependents =
            dependents
                .where(
                  (x) =>
                      x.name.toLowerCase().contains(searchController.text) ||
                      x.id == widget.selectedDependent,
                )
                .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetDependentsBloc, GetDependentsState>(
      listener: (context, state) {
        if (state is GetDependentsLoading) {
          setState(() {
            isLoadingData = true;
          });
        } else if (state is GetDependentsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Error on get dependents!")),
          );
          setState(() {
            isLoadingData = false;
            dependents = [];
          });
        } else if (state is GetDependentsSuccess) {
          setState(() {
            isLoadingData = false;
            dependents = state.dependents;
            filteredDependents = state.dependents;
            widget.onSelectDependent(null);
          });
        }
      },
      child: DashboardCard(
        flex: 3,
        floatingActionButton: ResponsiveChild(
          xs: SizedBox.shrink(),
          lg: FloatingActionButton(
            onPressed: () => _showAddDependentDialog(context),
            tooltip: 'Add Dependent',
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 3,
            child: Icon(Icons.add),
          ),
        ),
        children: [
          DashboardCardTitle(title: "List"),
          SizedBox(height: 20),

          MySearchInput(controller: searchController),
          SizedBox(height: 20),

          ResponsiveChild(
            xs:
                isLoadingData
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MySelectField(
                          label: "",
                          items:
                              filteredDependents
                                  .map(
                                    (val) => DropdownMenuItem(
                                      value: val.id,
                                      child: Text(val.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) => widget.onSelectDependent(val as String),
                          value: widget.selectedDependent,
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton(
                            onPressed: () => _showAddDependentDialog(context),
                            tooltip: 'Add Dependent',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            mini: true,
                            child: Icon(Icons.add),
                          ),
                        ),
                      ],
                    ),
            lg:
                isLoadingData
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                      children: [
                        if (filteredDependents.isEmpty)
                          Text("No dependents to show"),
                        ...filteredDependents.map((e) {
                          return DashboardListItem(
                            label: e.name,
                            value: e.id,
                            isSelected: widget.selectedDependent == e.id,
                            onSelect: (val) => widget.onSelectDependent(val),
                          );
                        }),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  void _showAddDependentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider(
            create:
                (context) => AddDependentBloc(
                  FirebaseDependentsRepo(
                    userId: context.read<AuthenticationBloc>().state.user!.id,
                  ),
                ),
            child: AddDependentDialog(
              onAdd: () {
                context.read<GetDependentsBloc>().add(GetDependents());
              },
            ),
          ),
    );
  }
}
