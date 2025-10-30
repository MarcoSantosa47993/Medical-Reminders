import 'package:flutter/material.dart';
import 'package:medicins_schedules/src/components/dashboard/dashboard.dart';
import 'package:medicins_schedules/src/modules/medicins/forms/medicin_data_form.dart';
import 'package:medicins_repository/medicins_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicins_schedules/src/blocs/authentication/authentication_bloc.dart';
import 'package:medicins_schedules/src/modules/medicins/blocs/get_medicin/get_medicin_bloc.dart';

class MedicinsFormsCard extends StatefulWidget {
  final String? medicinId;
  final String? dependentId;
  const MedicinsFormsCard({super.key, required this.medicinId, required this.dependentId});

  @override
  State<MedicinsFormsCard> createState() => _MedicinsFormsCardState();
}

class _MedicinsFormsCardState extends State<MedicinsFormsCard> {
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      flex: 8,
      children: [
        if (widget.medicinId == null) ...[
          Icon(Icons.search),
          Center(child: Text("Add a new Medicin")),
        ] else
          ...content(),
      ],
    );
  }

  List<Widget> content() {
    final userId = context.read<AuthenticationBloc>().state.user!.id;

    return [
      SizedBox(height: 30),
      DashboardCardTitle(title: "Medicin Data"),
      SizedBox(height: 20),
      BlocProvider(
        create:
            (context) =>
                GetMedicinBloc(FirebaseMedicinsRepo(userId: userId, dependentId: widget.dependentId))
                  ..add(GetMedicin(medicinId: widget.medicinId!)),

        child: MedicinDataForm(),
      ),
    ];
  }
}
