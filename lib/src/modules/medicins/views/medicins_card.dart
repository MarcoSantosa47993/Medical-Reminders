import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/blocs/get_medicins/get_medicins_bloc.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/components/form/form.dart';
import 'package:medicins_schedules/src/modules/medicins/blocs/add_medicin/add_medicin_bloc.dart';
import 'package:medicins_schedules/src/modules/medicins/views/add_medicin_dialog.dart';
import 'package:responsiveness/responsiveness.dart';

class MedicinsCard extends StatefulWidget {
  final Function(String?) onSelectMedicin;
  final String? selectedMedicin;
  final String? dependentId;

  const MedicinsCard({
    super.key,
    required this.onSelectMedicin,
    required this.selectedMedicin,
    required this.dependentId,
  });

  @override
  State<MedicinsCard> createState() => _MedicinsCardState();
}

class _MedicinsCardState extends State<MedicinsCard> {
  final searchController = TextEditingController(text: "");

  bool isLoadingData = true;
  List<Medicin> medicins = [];
  List<Medicin> filteredMedicins = [];
  Medicin? currentMedicin;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        filteredMedicins =
            medicins
                .where(
                  (x) =>
                      x.name.toLowerCase().contains(searchController.text) ||
                      x.id == widget.selectedMedicin,
                )
                .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetMedicinsBloc, GetMedicinsState>(
      listener: (context, state) {
        if (state is GetMedicinsLoading) {
          setState(() {
            isLoadingData = true;
          });
        } else if (state is GetMedicinsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text("Error on get Medicins!")),
          );
          setState(() {
            isLoadingData = false;
            medicins = [];
          });
        } else if (state is GetMedicinsSuccess) {
          setState(() {
            isLoadingData = false;
            medicins = state.medicins;
            filteredMedicins = state.medicins;
            widget.onSelectMedicin(null);
          });
        }
      },
      child: DashboardCard(
        flex: 3,
        floatingActionButton: ResponsiveChild(
          xs: SizedBox.shrink(),
          lg: FloatingActionButton(
            onPressed: () => _showAddMedicinDialog(context),
            tooltip: 'Add Medication',
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
                              filteredMedicins
                                  .map(
                                    (val) => DropdownMenuItem(
                                      value: val.id,
                                      child: Text(val.name),
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              (val) => widget.onSelectMedicin(val as String),
                          value: widget.selectedMedicin,
                        ),
                        SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerRight,
                          child: FloatingActionButton(
                            onPressed: () => _showAddMedicinDialog(context),
                            tooltip: 'Add Medicin',
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
                        if (filteredMedicins.isEmpty)
                          Text("No Medicins to show"),
                        ...filteredMedicins.map((e) {
                          return DashboardListItem(
                            label: e.name,
                            value: e.id,
                            isSelected: widget.selectedMedicin == e.id,
                            onSelect: (val) => widget.onSelectMedicin(val),
                          );
                        }),
                      ],
                    ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => BlocProvider(
            create:
                (context) => AddMedicinBloc(
                  FirebaseMedicinsRepo(
                    userId: context.read<AuthenticationBloc>().state.user!.id,
                    dependentId: widget.dependentId,
                  ),
                ),
            child: AddMedicinDialog(
              onAdd: () {
                context.read<GetMedicinsBloc>().add(GetMedicins());
              },
            ),
          ),
    );
  }
}
